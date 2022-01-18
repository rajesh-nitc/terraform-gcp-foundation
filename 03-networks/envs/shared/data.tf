data "google_active_folder" "common" {
  display_name = "${var.folder_prefix}-${local.env}"
  parent       = local.parent_id
}

data "google_netblock_ip_ranges" "private-googleapis" {
  range_type = "private-googleapis"
}

data "google_netblock_ip_ranges" "dns-forwarders" {
  range_type = "dns-forwarders"
}