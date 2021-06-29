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

module "gke" {
  source                            = "terraform-google-modules/kubernetes-engine/google//modules/beta-private-cluster"
  version                           = "15.0.0"
  project_id                        = local.project_id
  name                              = "${var.app_name}-${local.environment_code}-${var.region}"
  regional                          = false
  zones                             = ["${var.region}-a"]
  network                           = local.network_name
  subnetwork                        = local.subnet_name
  network_project_id                = local.host_project_id
  ip_range_pods                     = local.range_name_pod[0]
  ip_range_services                 = local.range_name_svc[0]
  add_cluster_firewall_rules        = false
  add_master_webhook_firewall_rules = false
  add_shadow_firewall_rules         = false
  deploy_using_private_endpoint     = var.deploy_using_private_endpoint
  enable_private_endpoint           = var.enable_private_endpoint
  impersonate_service_account       = var.project_service_account
  master_ipv4_cidr_block            = var.master_ipv4_cidr_block
  remove_default_node_pool          = true
  enable_private_nodes              = true
  identity_namespace                = "${local.project_id}.svc.id.goog"
  istio                             = true

  enable_l4_ilb_subsetting = false
  http_load_balancing      = true
  network_policy           = true

  master_authorized_networks = concat(var.master_authorized_networks,
    var.provision_bastion_instance ?
    [
      {
        cidr_block   = "${module.bastion[0].ip_address}/32",
        display_name = "bastion in same subnet as cluster"
      }
    ] : []
  )

  cluster_resource_labels = {
    "mesh_id" = "proj-${data.google_project.gke_project.number}"
  }

  node_pools_tags = {
    "np-${var.region}" = ["allow-google-apis", "allow-lb"]
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
  create_service_account = false
  service_account        = "node-sa@${local.project_id}.iam.gserviceaccount.com"
}

module "bastion" {
  source                       = "../bastion"
  count                        = var.provision_bastion_instance ? 1 : 0
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