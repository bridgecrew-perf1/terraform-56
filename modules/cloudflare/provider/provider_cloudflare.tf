provider "cloudflare" {
  version = "=> x.x.x"
  email      = ""
  api_key    = ""
  account_id = ""
}

terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    #   version = "=> x.x.x"
    }
  }
}