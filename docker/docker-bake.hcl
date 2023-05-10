group "default" {
  targets = [
    # CPU
    "base",
    "nb-omnibus",
    "nb-image-class",
    "nb-gene-expr-pred",
  ]
}

group "gpu" {
  targets = [
    # GPU
    "gpu-nb-omnibus",
  ]
}

variable "TF_VERSION" {
  default = "2.12.0"
}

variable "REGISTRY" {
  default = "quay.io/entropyorg/"
}

variable "IMAGE" {
  default = "perl-ai-tensorflow-libtensorflow"
}

variable "NB_USER" {
  default = "jovyan"
}

variable "NB_UID" {
  default = 1000
}

target "nb-all" {
  args = {
    NB_USER = NB_USER
    NB_UID  = NB_UID
    TF_VERSION = TF_VERSION
  }
}

target "nb-cpu" {
  inherits   = [ "nb-all" ]
  args = {
    TF_DEVICE_TYPE = "cpu"
    TF_DEVICE_TAG  = ""
  }
}

target "nb-gpu" {
  inherits   = [ "nb-all" ]
  args = {
    TF_DEVICE_TYPE = "gpu"
    TF_DEVICE_TAG  = "-gpu"
  }
}

target "base" {
  inherits   = [ "nb-all" ]
  dockerfile = "docker/Dockerfile"
  target     = "base"
  tags = [
    "${REGISTRY}${IMAGE}:latest",
    "${REGISTRY}${IMAGE}:${TF_VERSION}",
  ]
}

target "nb-image-class" {
  inherits   = [ "nb-all" ]
  dockerfile = "docker/Dockerfile.nb-image-class"
  target     = "image-classification"
  contexts = {
    base           = "target:base"
  }
  tags = [
    "${REGISTRY}${IMAGE}:latest-nb-image-class",
    "${REGISTRY}${IMAGE}:${TF_VERSION}-nb-image-class",
  ]
}

target "nb-gene-expr-pred" {
  inherits   = [ "nb-all" ]
  dockerfile = "docker/Dockerfile.nb-gene-expr-pred"
  target     = "gene-expression-prediction"
  contexts = {
    base           = "target:base"
  }
  tags = [
    "${REGISTRY}${IMAGE}:latest-nb-gene-expr-pred",
    "${REGISTRY}${IMAGE}:${TF_VERSION}-nb-gene-expr-pred",
  ]
}

target "nb-omnibus" {
  inherits   = [ "nb-all" ]
  dockerfile = "docker/Dockerfile.nb-omnibus"
  contexts = {
    base               = "target:base"
    nb-image-class     = "target:nb-image-class"
    nb-gene-expr-pred  = "target:nb-gene-expr-pred"
  }
  tags = [
    "${REGISTRY}${IMAGE}:latest-nb-omnibus",
    "${REGISTRY}${IMAGE}:${TF_VERSION}-nb-omnibus",
  ]
}

target "gpu-nb-omnibus" {
  inherits   = [ "nb-gpu" ]
  args = {
    NB_APT_PKGS_RUN = <<EOF
      libjpeg-turbo8     libpng16-16 libgsl23
      samtools libhts3 tabix libxml2 libexpat1 libdb5.3 netpbm gnuplot-nox
    EOF
  }
  dockerfile = "docker/Dockerfile.with-gpu-libtf"
  target     = "nb"
  contexts = {
    nb-base            = "target:nb-omnibus"
  }
  tags = [
    "${REGISTRY}${IMAGE}:latest-gpu-nb-omnibus",
    "${REGISTRY}${IMAGE}:${TF_VERSION}-gpu-nb-omnibus",
  ]
}
