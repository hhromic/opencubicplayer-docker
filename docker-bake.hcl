variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["ocp", "ocp-midi"]
}

target "ocp" {
  target = "ocp"
  tags = ["ghcr.io/hhromic/opencubicplayer:${TAG}"]
  labels = {
    "org.opencontainers.image.created" = timestamp()
  }
}

target "ocp-midi" {
  target = "ocp-midi"
  tags = ["ghcr.io/hhromic/opencubicplayer-midi:${TAG}"]
  labels = {
    "org.opencontainers.image.created" = timestamp()
  }
}
