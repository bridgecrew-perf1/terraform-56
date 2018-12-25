# Cloudflare Page Rule modules:

For these examples the values of the variables are stored on **hlc** files.

### Forwarding 301 rule:

```
module "cf301_www_http" {
  source = "<LOCAL_PATH>"
  cloudflare_zone = "${var.cloudflare_zone}"
  target = "${var.cloudflare_target_2}/*"
  priority = "3"
  forwarding_url = "${var.forwarding_url}"
  forwarding_status_code = 301
}
```

### SSL rule:

```
module "cfSsl" {
  source = "<LOCAL_PATH>"
  cloudflare_zone = "${var.cloudflare_zone}"
  target = "${var.cloudflare_target_0}/*"
  priority = "1"
  ssl_action = "full"
}
```
