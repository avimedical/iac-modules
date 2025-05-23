terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.36"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = ">= 6.36"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}