locals {
  prj_sa_dataproc_roles = [
    "roles/iam.serviceAccountUser",
  ]
}

resource "google_compute_subnetwork_iam_member" "sa_dataproc_networkuser" {
  for_each   = contains(var.activate_apis, "dataproc.googleapis.com") && var.vpc_type != "" ? local.shared_vpc_subnets_map : {}
  member     = format("serviceAccount:%s", local.service_prj_dataproc_sa)
  project    = local.svpc_host_project_id
  region     = each.value.region
  role       = "roles/compute.networkUser"
  subnetwork = each.value.self_link
}

# serviceAccountUser role to prj SA
resource "google_project_iam_member" "prj_sa_dataproc_roles" {
  for_each = contains(var.activate_apis, "dataproc.googleapis.com") ? toset(local.prj_sa_dataproc_roles) : []
  project  = module.project.project_id
  role     = each.value
  member   = "serviceAccount:${module.project.service_account_email}"
}