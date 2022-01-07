resource "google_service_account" "ad_mgmt_compute_sa" {
  account_id = "sa-ad-mgmt-compute"
  project    = var.project_id
}

module "instance_template" {
  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "7.0.0"
  machine_type         = "n1-standard-2"
  region               = var.region
  project_id           = var.project_id
  subnetwork           = var.subnet
  source_image_family  = "windows-2019"
  source_image_project = "windows-cloud"

  service_account = {
    email  = google_service_account.ad_mgmt_compute_sa.email
    scopes = ["cloud-platform"]
  }

  metadata = {
    sysprep-specialize-script-ps1 = "Install-WindowsFeature -Name RSAT-AD-Tools;Install-WindowsFeature -Name GPMC;Install-WindowsFeature -Name RSAT-DNS-Server"
  }

  tags = ["allow-google-apis", "allow-iap-rdp", "allow-win-activation", "allow-egress-to-ad"]
}

module "compute_instance" {
  source              = "terraform-google-modules/vm/google//modules/compute_instance"
  version             = "6.2.0"
  region              = var.region
  subnetwork          = var.subnet
  num_instances       = 1
  hostname            = "ad-mgmt"
  add_hostname_suffix = false
  instance_template   = module.instance_template.self_link
}