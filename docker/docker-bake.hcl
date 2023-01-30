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

target "nb-gene-expr-pred" {
  dockerfile = "docker/Dockerfile.nb-gene-expr-pred"
  target     = "gene-expression-prediction"
  contexts = {
    base           = "target:base"
  }
  tags = ["${REGISTRY}${IMAGE}:${TAG}-nb-gene-expr-pred"]
}

target "nb-omnibus" {
  dockerfile = "docker/Dockerfile.nb-omnibus"
  contexts = {
    base               = "target:base"
    nb-image-class     = "target:nb-image-class"
    nb-gene-expr-pred  = "target:nb-gene-expr-pred"
  }
  tags = ["${REGISTRY}${IMAGE}:${TAG}-nb-omnibus"]
}
