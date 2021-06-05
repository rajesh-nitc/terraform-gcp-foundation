locals {
  group_network_admins_roles = ["roles/compute.networkAdmin", "roles/compute.xpnAdmin", "roles/compute.securityAdmin", "roles/dns.admin"]
}

resource "google_organization_iam_member" "group_network_admins" {
  for_each = toset(local.group_network_admins_roles)
  org_id   = var.org_id
  role     = each.key
  member   = "group:${var.group_network_admins}"
}