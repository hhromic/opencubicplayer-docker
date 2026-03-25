variable "TAGS" {
  default = ["latest"]
  type = list(string)
}

variable "PLATFORMS" {
  default = []
  type = list(string)
}

variable "IMAGE_CREATED" {
  default = timestamp()
  type = string
}

variable "_metadata" {
  default = {
    "org.opencontainers.image.created" = IMAGE_CREATED
    "org.opencontainers.image.description" = "Unix port of Open Cubic Player, which is a text-based player with some few graphical views."
    "org.opencontainers.image.licenses" = "Apache-2.0 GPL-2.0"
    "org.opencontainers.image.source" = "https://github.com/hhromic/opencubicplayer-docker"
    "org.opencontainers.image.title" = "Open Cubic Player (Unix port)"
    "org.opencontainers.image.url" = "https://github.com/hhromic/opencubicplayer-docker"
    "org.opencontainers.image.vendor" = "https://github.com/hhromic"
    "org.opencontainers.image.version" = "3.2.0"
  }
  type = map(string)
}

target "default" {
  matrix = {
    tgt = ["opencubicplayer", "opencubicplayer-midi"]
  }
  name = tgt
  target = tgt
  tags = [for tag in TAGS: "ghcr.io/hhromic/${tgt}:${tag}"]
  platforms = PLATFORMS
  annotations = length(PLATFORMS) > 1 ? [for k, v in _metadata: "index,manifest:${k}=${v}"] : []
  labels = length(PLATFORMS) <= 1 ? _metadata : {}
  attest = [
    {"type" = "sbom", "disabled" = true},
    {"type" = "provenance", "disabled" = true},
  ]
}
