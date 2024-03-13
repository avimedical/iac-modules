provider "kubernetes" {
  cluster_ca_certificate = var.cluster_ca_certificate
  host                   = var.host
  token                  = var.token
}
