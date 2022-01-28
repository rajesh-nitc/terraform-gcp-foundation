# Dataproc sa
resource "google_compute_subnetwork_iam_member" "sa_dataproc_networkuser" {
  for_each   = contains(var.activate_apis, "dataproc.googleapis.com") && var.vpc_type != "" ? local.shared_vpc_subnets_map : {}
  member     = format("serviceAccount:%s", local.service_prj_dataproc_sa)
  project    = local.svpc_host_project_id
  region     = each.value.region
  role       = "roles/compute.networkUser"
  subnetwork = each.value.self_link
}

# Dataproc worker sa
resource "google_service_account" "worker_sa_dataproc" {
  count        = contains(var.activate_apis, "dataproc.googleapis.com") ? 1 : 0
  project      = module.project.project_id
  account_id   = "sa-dataproc-worker"
  display_name = "Dataproc worker SA"
}

resource "google_project_iam_member" "worker_sa_dataproc_role" {
  count   = contains(var.activate_apis, "dataproc.googleapis.com") ? 1 : 0
  project = module.project.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_service_account.worker_sa_dataproc[0].email}"
}

# Dataproc prj sa
resource "google_project_iam_member" "prj_sa_dataproc_role" {
  count   = contains(var.activate_apis, "dataproc.googleapis.com") ? 1 : 0
  project = module.project.project_id
  role    = "roles/dataproc.admin"
  member  = "serviceAccount:${module.project.service_account_email}"
}

resource "google_service_account_iam_member" "prj_sa_dataproc_sauser" {
  count              = contains(var.activate_apis, "dataproc.googleapis.com") ? 1 : 0
  service_account_id = google_service_account.worker_sa_dataproc[0].name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${module.project.service_account_email}"
}

