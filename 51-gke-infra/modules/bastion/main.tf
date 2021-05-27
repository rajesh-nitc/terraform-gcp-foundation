module "iap_bastion" {
  source  = "terraform-google-modules/bastion-host/google"
  version = "~> 3.1"
  project = var.project_id

  # Variables for existing network
  network      = var.bastion_network_self_link
  subnet       = var.bastion_subnet_self_link
  host_project = var.network_project_id

  # Customizable Variables
  name                 = var.bastion_name
  zone                 = var.bastion_zone
  service_account_name = var.bastion_service_account_name
  service_account_roles_supplemental = [
    "roles/compute.admin",
    "roles/gkehub.admin",
    "roles/container.admin",
    "roles/meshconfig.admin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountKeyAdmin",
    "roles/servicemanagement.admin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/privateca.admin"
  ]
  create_firewall_rule = false
  shielded_vm          = false
  members              = var.bastion_members
  tags                 = ["bastion", "allow-google-apis", "egress-internet", "allow-iap-ssh"]
}

# resource "google_project_iam_member" "bastion_repo_access" {
#   project = var.repo_project_id
#   role    = "roles/source.writer"
#   member  = "serviceAccount:${module.iap_bastion.service_account}"
# }
