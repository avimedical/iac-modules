terraform {
  required_version = ">=0.13.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.20.0"
    }
  }
}