data "google_active_folder" "env" {
  display_name = "${var.folder_prefix}-${var.environment}"
  parent       = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

data "google_projects" "loading_projects" {
  filter = "parent.id:${split("/", local.folder_id)[1]} name:*loading* labels.application_name=loading labels.business_code=${var.business_code} labels.environment=${var.environment} lifecycleState=ACTIVE"
}

data "google_project" "loading_project" {
  project_id = data.google_projects.loading_projects.projects[0].project_id
}