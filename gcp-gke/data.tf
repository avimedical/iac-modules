data "google_compute_subnetwork" "subnetwork" {
  name    = var.subnetwork_name
  project = var.project_id
  region  = var.region
}