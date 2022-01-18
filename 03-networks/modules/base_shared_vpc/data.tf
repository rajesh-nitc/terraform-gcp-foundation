data "google_netblock_ip_ranges" "legacy_health_checkers" {
  range_type = "legacy-health-checkers"
}

data "google_netblock_ip_ranges" "health_checkers" {
  range_type = "health-checkers"
}

data "google_netblock_ip_ranges" "iap_forwarders" {
  range_type = "iap-forwarders"
}

# 199.36.153.8/30
data "google_netblock_ip_ranges" "private-googleapis" {
  range_type = "private-googleapis"
}

# 199.36.153.4/30
data "google_netblock_ip_ranges" "restricted-googleapis" {
  range_type = "restricted-googleapis"
}