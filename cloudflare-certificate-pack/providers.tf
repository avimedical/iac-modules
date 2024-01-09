terraform {
  required_version = ">=0.13.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.21.0"
    }
  }
}