locals {
  environment_code                           = element(split("", var.environment), 0)
  folder_id                                  = data.google_active_folder.env.name
  project_id                                 = data.google_projects.gke_projects.projects[0].project_id
  k8s_ns_name_enforced_by_kustomize_overlays = "${var.k8s_app_service_name}-ns-${local.environment_code}"
  k8s_sa_name_enforced_by_kustomize_overlays = "${var.k8s_app_service_name}-ksa-${local.environment_code}"
  k8s_sa_gcp_derived_name                    = "serviceAccount:${local.project_id}.svc.id.goog[${local.k8s_ns_name_enforced_by_kustomize_overlays}/${local.k8s_sa_name_enforced_by_kustomize_overlays}]"
}

resource "google_service_account" "main" {
  account_id   = "sa-${var.k8s_app_service_name}-${var.app_name}"
  display_name = "GCP SA bound to KSA"
  project      = local.project_id
}

resource "google_service_account_iam_member" "main" {
  service_account_id = google_service_account.main.name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_sa_gcp_derived_name
}

resource "google_project_iam_member" "main" {
  for_each = toset(var.sa_roles)
  project  = local.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.main.email}"
}