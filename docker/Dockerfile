#syntax=docker/dockerfile-upstream:1.4.0-rc1

ARG TF_VERSION
ARG TF_DEVICE_TYPE
ARG TF_DEVICE_TAG

# Packages from Ubuntu focal base
ARG APT_PKGS_PERL="perl cpanminus"
ARG APT_PKGS_RUN="libffi7    libssl1.1  libzmq5"
ARG APT_PKGS_DEV="libffi-dev libssl-dev pkg-config"

# BUILDER

FROM perldocker/perl-tester:5.36 AS builder

ENV ALIEN_LIBTENSORFLOW_FROM_BINARY_VERSION=${TF_VERSION}
ENV ALIEN_LIBTENSORFLOW_DEVICE_TYPE=${TF_DEVICE_TYPE}

#COPY . /build
RUN git clone https://github.com/EntropyOrg/perl-AI-TensorFlow-Libtensorflow.git /build

WORKDIR /build

RUN cpm install -g $( dzil authordeps --missing )

RUN dzil build --in dist

# BASE

FROM tensorflow/tensorflow:${TF_VERSION}-jupyter AS base-builder

ARG APT_PKGS_PERL
ARG APT_PKGS_RUN
ARG APT_PKGS_DEV

COPY --from=builder /build/dist /build/dist

ENV ALIEN_LIBTENSORFLOW_FROM_BINARY_VERSION=${TF_VERSION}
ENV ALIEN_LIBTENSORFLOW_DEVICE_TYPE=${TF_DEVICE_TYPE}

RUN rm -Rfv /tf
RUN mkdir -p /tf

RUN apt-get update && apt-get install -y --no-install-recommends $APT_PKGS_PERL $APT_PKGS_RUN $APT_PKGS_DEV

RUN cpanm -nq App::plx App::cpm

# Init plx in /tf.
RUN bash -c 'cd /tf \
	&& plx --init \
	&& plx --config libspec add 10perl5-nb.ll     /perl5-nb && perl -Mlocal::lib=/perl5-nb \
	&& plx --config libspec add 00perl5-global.ll /perl5 \
	&& plx --cpanm -l /perl5 -nq App::cpm \
	'

# Install Jupyter kernel
RUN plx cpm install -L /perl5 Devel::IPerl

# Install the actual dist.
RUN plx cpm install -L /perl5 /build/dist \
	&& rm -Rf /build/dist

# Clean up
RUN apt-get remove -y $NB_APT_PKGS_DEV && apt-get autoremove

RUN apt-get -qq purge \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

RUN rm -Rf $HOME/.perl-cpm/ $HOME/.cpanm

FROM tensorflow/tensorflow:${TF_VERSION}${TF_DEVICE_TAG}-jupyter AS base

ARG APT_PKGS_PERL
ARG APT_PKGS_RUN

ARG NB_USER
ARG NB_UID

# Use bash as default shell, rather than sh
ENV SHELL /bin/bash

# Set up user
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN groupadd \
        --gid ${NB_UID} \
        ${NB_USER} && \
    useradd \
        --comment "Default user" \
        --create-home \
        --gid ${NB_UID} \
        --no-log-init \
        --shell /bin/bash \
        --uid ${NB_UID} \
        ${NB_USER}

COPY --from=base-builder /perl5 /perl5
COPY --from=base-builder /tf    /tf

# Get rid of upstream tutorials.
RUN rm -Rf /tf/tensorflow-tutorials

COPY .    /tf

RUN apt-get update && apt-get install -y --no-install-recommends $APT_PKGS_PERL $APT_PKGS_RUN

RUN cpanm -nq App::plx App::cpm

RUN apt-get -qq purge \
    && apt-get -qq clean \
    && rm -rf /var/lib/apt/lists/*

RUN rm -Rf $HOME/.perl-cpm/ $HOME/.cpanm

RUN chown -R ${NB_USER}:${NB_USER} /perl5 /tf

USER ${NB_USER}

RUN plx iperl --version # install kernel and exit

EXPOSE 8888

ENTRYPOINT [ "plx", "--base", "/tf", "--exec" ]
CMD [ "jupyter", "notebook", "--notebook-dir=/tf", "--ip", "0.0.0.0", "--no-browser" ]

# vim:ft=dockerfile
