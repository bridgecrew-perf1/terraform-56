resource "cloudflare_page_rule" "main" {
  zone = "${var.cloudflare_zone}"
  target = "${var.target}"
  priority = "${var.priority}"
  status = "${var.status}"
  actions = {
    forwarding_url = "${var.forwarding_url}"
  }
}