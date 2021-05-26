resource "google_compute_subnetwork_iam_member" "sa_gke_networkuser" {
  for_each   = contains(var.activate_apis, "container.googleapis.com") && var.vpc_type != "" ? local.shared_vpc_subnets_map : {}
  member     = format("serviceAccount:%s", local.gke_sa)
  project    = local.svpc_host_project_id
  region     = each.value.region
  role       = "roles/compute.networkUser"
  subnetwork = each.value.self_link
}

resource "google_project_iam_member" "gke_host_agent" {
  count   = contains(var.activate_apis, "container.googleapis.com") && var.vpc_type != "" ? 1 : 0
  project = local.svpc_host_project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = format("serviceAccount:%s", local.gke_sa)
}

resource "google_project_iam_member" "gke_security_admin" {
  count   = contains(var.activate_apis, "container.googleapis.com") && var.vpc_type != "" ? 1 : 0
  project = local.svpc_host_project_id
  role    = "roles/compute.securityAdmin"
  member  = format("serviceAccount:%s", local.gke_sa)
}