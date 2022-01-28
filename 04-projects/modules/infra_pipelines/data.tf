data "google_project" "automation_project" {
  project_id = var.automation_project_id
}

data "google_active_folder" "bootstrap" {
  display_name = "${var.folder_prefix}-bootstrap"
  parent       = local.parent_id
}

data "google_projects" "bootstrap_cb_project" {
  filter = "parent.id:${split("/", data.google_active_folder.bootstrap.name)[1]} labels.application_name=cloudbuild-bootstrap lifecycleState=ACTIVE"
}