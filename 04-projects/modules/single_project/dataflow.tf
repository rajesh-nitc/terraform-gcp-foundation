# Dataflow sa
resource "google_compute_subnetwork_iam_member" "sa_dataflow_networkuser" {
  for_each   = contains(var.activate_apis, "dataflow.googleapis.com") && var.vpc_type != "" ? local.shared_vpc_subnets_map : {}
  member     = format("serviceAccount:%s", local.service_prj_dataflow_sa)
  project    = local.svpc_host_project_id
  region     = each.value.region
  role       = "roles/compute.networkUser"
  subnetwork = each.value.self_link
}

# Dataflow worker sa
resource "google_service_account" "worker_sa_dataflow" {
  count        = contains(var.activate_apis, "dataflow.googleapis.com") ? 1 : 0
  project      = module.project.project_id
  account_id   = "sa-dataflow-worker"
  display_name = "Dataflow worker SA"
}

resource "google_project_iam_member" "worker_sa_dataflow_role" {
  count   = contains(var.activate_apis, "dataflow.googleapis.com") ? 1 : 0
  project = module.project.project_id
  role    = "roles/dataflow.worker"
  member  = "serviceAccount:${google_service_account.worker_sa_dataflow[0].email}"
}

# Dataflow prj sa
resource "google_project_iam_member" "prj_sa_dataflow_role" {
  count   = contains(var.activate_apis, "dataflow.googleapis.com") ? 1 : 0
  project = module.project.project_id
  role    = "roles/dataflow.admin"
  member  = "serviceAccount:${module.project.service_account_email}"
}

resource "google_service_account_iam_member" "prj_sa_dataflow_sauser" {
  count              = contains(var.activate_apis, "dataflow.googleapis.com") ? 1 : 0
  service_account_id = google_service_account.worker_sa_dataflow[0].name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${module.project.service_account_email}"
}