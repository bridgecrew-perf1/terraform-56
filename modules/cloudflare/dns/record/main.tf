
resource "cloudflare_record" "main" {
  domain = "${var.cloudflare_zone}"
  name   = "${var.name}"
  value  = "${var.value}"
  type   = "${var.type}"
  ttl    = "${var.ttl}"
  proxied = "${var.proxied}"
}