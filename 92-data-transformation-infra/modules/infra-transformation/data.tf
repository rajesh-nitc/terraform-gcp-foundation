data "google_active_folder" "env" {
  display_name = "${var.folder_prefix}-${var.environment}"
  parent       = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

data "google_projects" "transformation_projects" {
  filter = "parent.id:${split("/", local.folder_id)[1]} name:*transformation* labels.application_name=${var.business_code}-transformation labels.environment=${var.environment} lifecycleState=ACTIVE"
}

data "google_project" "transformation_project" {
  project_id = data.google_projects.transformation_projects.projects[0].project_id
}