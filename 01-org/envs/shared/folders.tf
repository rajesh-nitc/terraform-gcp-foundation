locals {
  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

/******************************************
  Top level folders
 *****************************************/

resource "google_folder" "common" {
  display_name = "${var.folder_prefix}-common"
  parent       = local.parent
}
