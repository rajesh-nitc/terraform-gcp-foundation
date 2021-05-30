module "gke_cluster" {
  source                 = "../../modules/single_cluster"
  org_id                 = var.org_id
  environment            = "development"
  app_name               = "budita"
  region                 = var.default_region
  groups_gke_security    = var.groups_gke_security
  master_ipv4_cidr_block = "100.64.78.0/28"

  master_authorized_networks = [
    {
      cidr_block   = "0.0.0.0/0",
      display_name = "To test cicd on cloudbuild"
    }
  ]

  node_pools = [
    {
      name               = "np-${var.default_region}"
      auto_repair        = true
      auto_upgrade       = true
      enable_secure_boot = true
      image_type         = "COS_CONTAINERD"
      machine_type       = "e2-standard-4"
      max_count          = 3
      min_count          = 1
      node_metadata      = "GKE_METADATA_SERVER"
    }
  ]
}
