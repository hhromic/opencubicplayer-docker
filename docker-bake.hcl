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
}

target "default" {
  name = tgt
  matrix = {
    tgt = ["opencubicplayer", "opencubicplayer-midi"],
  }
  target = tgt
  tags = [for tag in TAGS: "ghcr.io/hhromic/${tgt}:${tag}"]
  platforms = PLATFORMS
  attest = [
    {"type": "sbom", "disabled": true},
    {"type": "provenance", "disabled": true},
  ]
  labels = {
    "org.opencontainers.image.created" = IMAGE_CREATED
  }
}
