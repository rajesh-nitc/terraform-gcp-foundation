data "google_active_folder" "env" {
  display_name = "${var.folder_prefix}-development"
  parent       = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

module "test_vm_dev_sharedvpc" {
  source         = "../../modules/env_base"
  environment    = "development"
  vpc_type       = "base"
  num_instances  = 1
  machine_type   = "f1-micro"
  folder_id      = data.google_active_folder.env.name
  business_code  = "bu1"
  project_suffix = "sample-base"
  region         = var.instance_region
  app_name       = "sample-application"
  tags = [
    "allow-iap-ssh",
    "allow-google-apis",
  ]

}
