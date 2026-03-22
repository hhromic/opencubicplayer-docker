variable "TAG" {
  default = "latest"
}

variable "TAG_LATEST" {
  default = false
}

target "default" {
  name = tgt
  matrix = {
    tgt = ["opencubicplayer", "opencubicplayer-midi"],
  }
  target = tgt
  tags = [
    "ghcr.io/hhromic/${tgt}:${TAG}",
    TAG_LATEST ? "ghcr.io/hhromic/${tgt}:latest" : "",
  ]
  labels = {
    "org.opencontainers.image.created" = timestamp()
  }
}
