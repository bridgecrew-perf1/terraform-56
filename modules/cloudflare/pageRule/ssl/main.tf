resource "cloudflare_page_rule" "main" {
  zone = "${var.cloudflare_zone}"
  target = "${var.target}"
  priority = "${var.priority}"
  status = "${var.status}"
  actions = {
    ssl = "${var.ssl_action}"
  }
}