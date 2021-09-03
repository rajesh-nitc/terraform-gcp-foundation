# Serverless VPC Access
# TODO : create firewall rules to allow traffic from serverless service to vpc-connector
# TODO : create subnet for vpc-connector
# https://cloud.google.com/run/docs/configuring/connecting-shared-vpc
resource "google_compute_subnetwork_iam_member" "service_prj_vpcaccess_sa_networkuser" {
  for_each   = contains(var.activate_apis, "vpcaccess.googleapis.com") && var.vpc_type != "" ? local.shared_vpc_subnets_map : {}
  member     = format("serviceAccount:%s", local.service_prj_vpc_access_sa)
  project    = local.svpc_host_project_id
  region     = each.value.region
  role       = "roles/compute.networkUser"
  subnetwork = each.value.self_link
}

resource "google_compute_subnetwork_iam_member" "service_prj_google_apis_sa_networkuser_vpcaccess" {
  for_each   = contains(var.activate_apis, "vpcaccess.googleapis.com") && var.vpc_type != "" ? local.shared_vpc_subnets_map : {}
  member     = format("serviceAccount:%s", local.service_prj_google_apis_sa)
  project    = local.svpc_host_project_id
  region     = each.value.region
  role       = "roles/compute.networkUser"
  subnetwork = each.value.self_link
}