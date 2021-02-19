# Cloudflare DNS module:

For these examples the values of the variables are stored on **hlc** files.

This module is compatible with Terraform 14.x or higher.
### DNS Record example for 2.0 provider:

```
module "clouflare_record" {
  source = "./record/"
  zone_id = "123542etdfl345..."
  name = "record.boldlink.io"
  value = "lb.read-api.prd.boldlink.io"
  type = "CNAME"
}

provider "cloudflare" {
# Authentication - consider using variables so you don't hardcode it on your code
  email      = "example@boldlink.io"
  api_key    = "23wer4665..."
  account_id = "45ljlk345n3453..."
}

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}
```