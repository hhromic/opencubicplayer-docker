variable "TAGS" {
  default = ["latest"]
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
  labels = {
    "org.opencontainers.image.created" = IMAGE_CREATED
  }
}
