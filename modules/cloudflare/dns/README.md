# Cloudflare DNS module:

For these examples the values of the variables are stored on **hlc** files.

### DNS Record:

```
module "cfRecord_1" {
  source = "<LOCAL_PATH>"
  cloudflare_zone = "${var.cloudflare_zone}"
  name = "${var.cloudflare_fqdn_1}"
  value = "${var.cloudflare_s3_website}"
  type = "CNAME"
  ttl = "3600"
}
```