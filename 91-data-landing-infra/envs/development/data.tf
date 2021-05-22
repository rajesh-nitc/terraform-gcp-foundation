# data "google_projects" "network_projects" {
#   filter = "parent.id:${split("/", var.folder_id)[1]} labels.application_name=${var.vpc_type}-shared-vpc-host labels.environment=${var.environment} lifecycleState=ACTIVE"
# }

# data "google_project" "network_project" {
#   project_id = data.google_projects.network_projects.projects[0].project_id
# }

data "google_projects" "landing_projects" {
  filter = "parent.id:${split("/", var.folder_id)[1]} name:*${var.project_suffix}* labels.application_name=${var.business_code}-landing labels.environment=${var.environment} lifecycleState=ACTIVE"
}

data "google_project" "landing_project" {
  project_id = data.google_projects.landing_projects.projects[0].project_id
}

# data "google_compute_network" "shared_vpc" {
#   name    = "vpc-${local.environment_code}-shared-${var.vpc_type}"
#   project = data.google_project.network_project.project_id
# }

# data "google_compute_subnetwork" "subnetwork" {
#   name    = "sb-${local.environment_code}-shared-${var.vpc_type}-${var.region}"
#   region  = var.region
#   project = data.google_project.network_project.project_id
# }
