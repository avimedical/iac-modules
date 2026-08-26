resource "google_service_account" "sa" {
  # Explicit, not inherited from the provider's default project. Callers whose
  # cluster lives outside the provider's project would otherwise create the SA
  # in the wrong project while its IAM bindings below target var.project_id.
  project      = var.project_id
  account_id   = var.sa_name
  display_name = var.sa_display_name
}

resource "google_service_account_iam_member" "sa_iam_binding_workload_identity_user" {
  service_account_id = google_service_account.sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[cnrm-system/cnrm-controller-manager-${var.namespace}]"
  depends_on         = [google_service_account.sa]
}

// Add roles to the service account
resource "google_project_iam_member" "sa_iam_binding_roles" {
  for_each   = toset(var.roles)
  project    = var.project_id
  role       = each.key
  member     = "serviceAccount:${var.sa_name}@${var.project_id}.iam.gserviceaccount.com"
  depends_on = [google_service_account.sa]
}
