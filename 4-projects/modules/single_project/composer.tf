resource "google_compute_subnetwork_iam_member" "sa_composer_networkuser" {
  for_each   = contains(var.activate_apis, "composer.googleapis.com") && var.vpc_type != "" ? local.shared_vpc_subnets_map : {}
  member     = format("serviceAccount:%s", local.service_prj_composer_sa)
  project    = local.svpc_host_project_id
  region     = each.value.region
  role       = "roles/compute.networkUser"
  subnetwork = each.value.self_link
}

resource "google_project_iam_member" "composer_host_agent" {
  count   = contains(var.activate_apis, "composer.googleapis.com") && var.vpc_type != "" ? 1 : 0
  project = local.svpc_host_project_id
  role    = "roles/composer.sharedVpcAgent"
  member  = format("serviceAccount:%s", local.service_prj_composer_sa)
}