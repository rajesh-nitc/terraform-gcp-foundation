locals {
  environment_code  = element(split("", var.environment), 0)
  folder_id         = data.google_active_folder.env.name
  project_id        = data.google_projects.gke_projects.projects[0].project_id
  host_project_id   = data.google_project.network_project.project_id
  network_name      = data.google_compute_network.shared_vpc.name
  subnet_name       = data.google_compute_subnetwork.subnetwork.name
  network_self_link = data.google_compute_network.shared_vpc.self_link
  subnet_self_link  = data.google_compute_subnetwork.subnetwork.self_link
  range_name_pod    = [for i in data.google_compute_subnetwork.subnetwork.secondary_ip_range : i.range_name if can(regex("pod", i.range_name))]
  range_name_svc    = [for i in data.google_compute_subnetwork.subnetwork.secondary_ip_range : i.range_name if can(regex("svc", i.range_name))]
}

module "gke_cluster" {
  source = "git@github.com:terraform-google-modules/terraform-google-kubernetes-engine.git//modules/safer-cluster?ref=v14.3.0"

  project_id         = local.project_id
  network_project_id = local.host_project_id
  network            = local.network_name

  name                         = "gke-${local.environment_code}-${var.app_name}-${var.region}"
  subnetwork                   = local.subnet_name
  ip_range_pods                = local.range_name_pod[0]
  ip_range_services            = local.range_name_svc[0]
  master_ipv4_cidr_block       = var.master_ipv4_cidr_block
  region                       = var.region
  authenticator_security_group = var.groups_gke_security
  master_authorized_networks = concat(var.master_authorized_networks,
    [
      {
        cidr_block   = "${module.bastion.ip_address}/32",
        display_name = "bastion in same subnet as cluster"
      }
    ]
  )

  cluster_resource_labels = {
    "mesh_id" = "proj-${data.google_project.gke_project.number}"
  }

  node_pools_tags = {
    "np-${var.region}" = ["gke-${var.app_name}-cluster", "allow-google-apis", "egress-internet", "allow-lb"]
  }

  node_pools = var.node_pools

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
    default-node-pool = []
  }
  compute_engine_service_account = "node-sa@${data.google_projects.gke_projects.projects[0].project_id}.iam.gserviceaccount.com"
}

module "bastion" {
  source                       = "../bastion"
  project_id                   = local.project_id
  bastion_name                 = "gce-bastion"
  bastion_zone                 = "${var.region}-a"
  bastion_service_account_name = "gce-bastion-sa"
  bastion_members              = var.bastion_members
  bastion_network_self_link    = local.network_self_link
  bastion_subnet_self_link     = local.subnet_self_link
  bastion_region               = var.region
  network_project_id           = local.host_project_id
}

