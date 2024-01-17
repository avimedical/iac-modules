terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 5.11"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
  required_version = ">= 0.13"
}