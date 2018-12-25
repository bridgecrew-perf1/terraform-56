resource "cloudflare_page_rule" "main" {
  zone = "${var.cloudflare_zone}"
  target = "${var.target}"
  priority = "${var.priority}"
  status = "${var.status}"
  actions = {
    forwarding_url {
      url = "${var.forwarding_url}"
      status_code = "${var.forwarding_status_code}"
    }
  }
}