group "default" {
  targets = ["base", "nb-omnibus"]
}

variable "REGISTRY" {
  default = "quay.io/entropyorg/"
}

variable "IMAGE" {
  default = "perl-ai-tensorflow-libtensorflow"
}

variable "TAG" {
  default = "latest"
}

target "base" {
  dockerfile = "docker/Dockerfile"
  target     = "base"
  tags = ["${REGISTRY}${IMAGE}:${TAG}"]
}

target "nb-image-class" {
  dockerfile = "docker/Dockerfile.nb-image-class"
  target     = "image-classification"
  contexts = {
    base           = "target:base"
  }
  tags = ["${REGISTRY}${IMAGE}:${TAG}-nb-image-class"]
}

target "nb-bioinfo" {
  dockerfile = "docker/Dockerfile.nb-bioinfo"
  target     = "bioinformatics"
  contexts = {
    base           = "target:base"
  }
  tags = ["${REGISTRY}${IMAGE}:${TAG}-nb-bioinfo"]
}

target "nb-omnibus" {
  dockerfile = "docker/Dockerfile.nb-omnibus"
  contexts = {
    base           = "target:base"
    nb-image-class = "target:nb-image-class"
    nb-bioinfo     = "target:nb-bioinfo"
  }
  tags = ["${REGISTRY}${IMAGE}:${TAG}-nb-omnibus"]
}
