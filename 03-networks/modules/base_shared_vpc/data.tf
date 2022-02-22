# 35.191.0.0/16, 209.85.152.0/22, 209.85.204.0/22
data "google_netblock_ip_ranges" "legacy_health_checkers" {
  range_type = "legacy-health-checkers"
}

# 35.191.0.0/16, 130.211.0.0/22
data "google_netblock_ip_ranges" "health_checkers" {
  range_type = "health-checkers"
}

# 35.235.240.0/20
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