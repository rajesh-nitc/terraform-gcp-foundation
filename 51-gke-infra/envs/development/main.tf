module "gke_cluster" {
  source                        = "../../modules/single_cluster"
  org_id                        = var.org_id
  environment                   = "development"
  app_name                      = "budita"
  region                        = var.default_region
  project_service_account       = var.project_service_account
  groups_gke_security           = var.groups_gke_security
  enable_private_endpoint       = false
  deploy_using_private_endpoint = false
  provision_bastion_instance    = false
  master_ipv4_cidr_block        = "100.64.80.0/28"

  master_authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0",
      display_name = "To test cicd on cloudbuild"
    }
  ]

  node_pools = [
    {
      name               = "np-${var.default_region}"
      machine_type       = "e2-standard-4"
      node_locations     = "us-central1-b,us-central1-c"
      min_count          = 1
      max_count          = 3
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
      initial_node_count = 1
    },
  ]
}
