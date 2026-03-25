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

target "default" {
  matrix = {
    tgt = ["opencubicplayer", "opencubicplayer-midi"]
  }
  name = tgt
  target = tgt
  tags = [for tag in TAGS: "ghcr.io/hhromic/${tgt}:${tag}"]
  platforms = PLATFORMS
  attest = [
    {"type" = "sbom", "disabled" = true},
    {"type" = "provenance", "disabled" = true},
  ]
  labels = {
    "org.opencontainers.image.created" = IMAGE_CREATED
  }
}
