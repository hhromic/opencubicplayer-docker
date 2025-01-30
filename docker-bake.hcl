variable "TAG" {
  default = "latest"
}

group "default" {
  targets = ["ocp", "ocp-midi"]
}

target "ocp" {
  target = "ocp"
  tags = ["ghcr.io/hhromic/opencubicplayer:${TAG}"]
}

target "ocp-midi" {
  target = "ocp-midi"
  tags = ["ghcr.io/hhromic/opencubicplayer-midi:${TAG}"]
}
