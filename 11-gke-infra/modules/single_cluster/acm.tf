data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "acm" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/acm"
  version = "~> 21.2"

  project_id       = local.project_id
  cluster_name     = module.gke.name
  location         = module.gke.location
  cluster_endpoint = module.gke.endpoint

  sync_repo   = var.sync_repo
  sync_branch = var.sync_branch
  policy_dir  = var.policy_dir
}