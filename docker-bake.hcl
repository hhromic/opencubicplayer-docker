variable "TAGS" {
  default = ["latest"]
  type = list(string)
}

target "default" {
  name = tgt
  matrix = {
    tgt = ["opencubicplayer", "opencubicplayer-midi"],
  }
  target = tgt
  tags = [for tag in TAGS: "ghcr.io/hhromic/${tgt}:${tag}"]
  labels = {
    "org.opencontainers.image.created" = timestamp()
  }
}
