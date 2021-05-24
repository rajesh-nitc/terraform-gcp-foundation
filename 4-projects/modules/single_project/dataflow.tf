# Allow Dataflow access to shared subnets
resource "google_compute_subnetwork_iam_member" "sa_dataflow_networkuser" {
  provider = google-beta
  count    = contains(var.activate_apis, "dataflow.googleapis.com") && var.vpc_type != "" ? 1 : 0
  member   = format("serviceAccount:service-%s@dataflow-service-producer-prod.iam.gserviceaccount.com", module.project.project_number)
  project  = local.svpc_host_project_id
  region = element(
    split("/", local.shared_vpc_subnets[count.index]),
    index(split("/", local.shared_vpc_subnets[count.index]), "regions") + 1,
  )
  role = "roles/compute.networkUser"
  subnetwork = element(
    split("/", local.shared_vpc_subnets[count.index]),
    index(
      split("/", local.shared_vpc_subnets[count.index]),
      "subnetworks",
    ) + 1,
  )
}
