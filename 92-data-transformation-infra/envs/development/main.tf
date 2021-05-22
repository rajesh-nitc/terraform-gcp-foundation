# data "google_active_folder" "env" {
#   display_name = "${var.folder_prefix}-development"
#   parent       = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
# }

