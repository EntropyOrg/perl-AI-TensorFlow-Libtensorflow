group "default" {
  targets = [
    # CPU
    "base",
    "nb-omnibus",
    "nb-image-class",
    "nb-gene-expr-pred",
    "nb-obj-detect",
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

function "TF_LATEST_VERSION" {
  params = []
  result = "2.12.0" # current upstream version
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

function "device2tag" {
  params = [device]
  result = equal(device,"cpu") ? "" : equal(device,"gpu") ? "-gpu" : ""
}

function "tag" {
  params = [device, suffix]
  result = [
    "${REGISTRY}${IMAGE}:${TF_VERSION}${device2tag(device)}${suffix}",
    equal(TF_VERSION, TF_LATEST_VERSION())
      ? "${REGISTRY}${IMAGE}:latest${device2tag(device)}${suffix}"
      : "",
  ]
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
    TF_DEVICE_TAG  = "${device2tag("cpu")}"
  }
}

target "nb-gpu" {
  inherits   = [ "nb-all" ]
  args = {
    TF_DEVICE_TYPE = "gpu"
    TF_DEVICE_TAG  = "${device2tag("gpu")}"
  }
}

target "base" {
  inherits   = [ "nb-cpu" ]
  dockerfile = "docker/Dockerfile"
  target     = "base"
  tags = tag("cpu", "")
}

target "nb-image-class" {
  inherits   = [ "nb-cpu" ]
  dockerfile = "docker/Dockerfile.nb-image-class"
  target     = "image-classification"
  contexts = {
    base           = "target:base"
  }
  tags = tag("cpu", "-nb-image-class")
}

target "nb-gene-expr-pred" {
  inherits   = [ "nb-cpu" ]
  dockerfile = "docker/Dockerfile.nb-gene-expr-pred"
  target     = "gene-expression-prediction"
  contexts = {
    base           = "target:base"
  }
  tags = tag("cpu", "-nb-gene-expr-pred")
}

target "nb-obj-detect" {
  inherits   = [ "nb-cpu" ]
  dockerfile = "docker/Dockerfile.nb-obj-detect"
  target     = "object-detection"
  contexts = {
    base           = "target:base"
  }
  tags = tag("cpu", "-nb-obj-detect")
}

target "nb-omnibus" {
  inherits   = [ "nb-cpu" ]
  dockerfile = "docker/Dockerfile.nb-omnibus"
  contexts = {
    base               = "target:base"
    nb-image-class     = "target:nb-image-class"
    nb-gene-expr-pred  = "target:nb-gene-expr-pred"
    nb-obj-detect      = "target:nb-obj-detect"
  }
  tags = tag("cpu", "-nb-omnibus")
}

target "gpu-nb-omnibus" {
  inherits   = [ "nb-gpu" ]
  args = {
    NB_APT_PKGS_RUN = <<EOF
      libjpeg-turbo8     libpng16-16 libgsl23
      samtools libhts3 tabix libxml2 libexpat1 libdb5.3 netpbm gnuplot-nox
      libjpeg-turbo8     libpng16-16 netpbm gnuplot-nox
    EOF
  }
  dockerfile = "docker/Dockerfile.with-gpu-libtf"
  target     = "nb"
  contexts = {
    nb-base            = "target:nb-omnibus"
  }
  tags = tag("gpu", "-nb-omnibus")
}
