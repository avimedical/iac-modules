variable "sa_name" {}
variable "namespace" {}
variable "environment" {}
variable "domain" {}

// Unused since the move to JWT auth; kept optional so callers that still pass them keep working.
variable "kubernetes_host" {
  default = null
}
variable "kubernetes_ca_cert" {
  default = null
}
