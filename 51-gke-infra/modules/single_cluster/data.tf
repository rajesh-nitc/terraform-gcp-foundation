data "google_active_folder" "env" {
  display_name = "${var.folder_prefix}-${var.environment}"
  parent       = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

data "google_projects" "network_projects" {
  filter = "parent.id:${split("/", local.folder_id)[1]} labels.application_name=${var.vpc_type}-shared-vpc-host labels.environment=${var.environment} lifecycleState=ACTIVE"
}

data "google_project" "network_project" {
  project_id = data.google_projects.network_projects.projects[0].project_id
}

data "google_projects" "gke_projects" {
  filter = "parent.id:${split("/", local.folder_id)[1]} name:*gke* labels.application_name=${var.business_code}-${var.app_name} labels.environment=${var.environment} lifecycleState=ACTIVE"
}

data "google_project" "gke_project" {
  project_id = data.google_projects.gke_projects.projects[0].project_id
}

data "google_compute_network" "shared_vpc" {
  name    = "vpc-${local.environment_code}-shared-${var.vpc_type}"
  project = data.google_project.network_project.project_id
}

data "google_compute_subnetwork" "subnetwork" {
  name    = "sb-${local.environment_code}-shared-${var.vpc_type}-${var.region}-${var.business_code}"
  region  = var.region
  project = data.google_project.network_project.project_id
}