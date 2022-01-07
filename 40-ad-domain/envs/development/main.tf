module "project_services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 11.1"

  project_id    = var.host_project_id
  activate_apis = ["managedidentities.googleapis.com"]

}

# Took 32 mins
resource "google_active_directory_domain" "ad-domain" {
  project             = var.host_project_id
  domain_name         = var.domain_name
  admin               = "setupadmin"
  locations           = var.regions
  reserved_ip_range   = var.reserved_ip_range
  authorized_networks = ["projects/${var.host_project_id}/global/networks/${var.network_name}"]
  depends_on          = [module.project_services]
}