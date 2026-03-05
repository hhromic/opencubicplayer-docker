variable "TAG" {
  default = "latest"
}

variable "TAG_LATEST" {
  default = false
}

group "default" {
  targets = ["ocp", "ocp-midi"]
}

target "ocp" {
  target = "ocp"
  tags = [
    "ghcr.io/hhromic/opencubicplayer:${TAG}",
    TAG_LATEST ? "ghcr.io/hhromic/opencubicplayer:latest" : "",
  ]
  labels = {
    "org.opencontainers.image.created" = timestamp()
  }
}

target "ocp-midi" {
  target = "ocp-midi"
  tags = [
    "ghcr.io/hhromic/opencubicplayer-midi:${TAG}",
    TAG_LATEST ? "ghcr.io/hhromic/opencubicplayer-midi:latest" : "",
  ]
  labels = {
    "org.opencontainers.image.created" = timestamp()
  }
}
