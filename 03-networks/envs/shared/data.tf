data "google_active_folder" "common" {
  display_name = "${var.folder_prefix}-${local.env}"
  parent       = local.parent_id
}

# 199.36.153.8/30
data "google_netblock_ip_ranges" "private-googleapis" {
  range_type = "private-googleapis"
}

# 35.199.192.0/19
data "google_netblock_ip_ranges" "dns-forwarders" {
  range_type = "dns-forwarders"
}