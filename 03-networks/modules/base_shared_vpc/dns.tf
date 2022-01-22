locals {
  parent_id = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

data "google_active_folder" "common" {
  display_name = "${var.folder_prefix}-common"
  parent       = local.parent_id
}

/******************************************
  DNS Hub Project
*****************************************/

data "google_projects" "dns_hub" {
  filter = "parent.id:${split("/", data.google_active_folder.common.name)[1]} labels.application_name=org-dns-hub lifecycleState=ACTIVE"
}

data "google_compute_network" "vpc_dns_hub" {
  name    = "vpc-c-dns-hub"
  project = data.google_projects.dns_hub.projects[0].project_id
}

/******************************************
  Default DNS Policy
 *****************************************/

resource "google_dns_policy" "default_policy" {
  project                   = var.project_id
  name                      = "dp-${var.environment_code}-shared-base-default-policy"
  enable_inbound_forwarding = var.dns_enable_inbound_forwarding
  enable_logging            = var.dns_enable_logging
  networks {
    network_url = module.main.network_self_link
  }
}

/******************************************
  Private Google APIs DNS Zone & records.
 *****************************************/

module "private_googleapis" {
  count       = var.enable_dns_zone_private_googleapis ? 1 : 0
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.1"
  project_id  = var.project_id
  type        = "private"
  name        = "dz-${var.environment_code}-shared-base-apis"
  domain      = "googleapis.com."
  description = "Private DNS zone to configure private.googleapis.com"

  private_visibility_config_networks = [
    module.main.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["restricted.googleapis.com."]
    },
    {
      name    = "private"
      type    = "A"
      ttl     = 300
      records = local.private_googleapis_cidr_hosts_list
    },
    {
      name    = "restricted"
      type    = "A"
      ttl     = 300
      records = local.restricted_googleapis_cidr_hosts_list
    },
    {
      name    = "securitycenter"
      type    = "CNAME"
      ttl     = 300
      records = ["private.googleapis.com."]
    },
  ]
}

/******************************************
  Private GCR DNS Zone & records.
 *****************************************/

module "base_gcr" {
  count       = var.enable_dns_zone_gcr ? 1 : 0
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.1"
  project_id  = var.project_id
  type        = "private"
  name        = "dz-${var.environment_code}-shared-base-gcr"
  domain      = "gcr.io."
  description = "Private DNS zone to configure gcr.io"

  private_visibility_config_networks = [
    module.main.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["gcr.io."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = local.private_googleapis_cidr_hosts_list
    },
  ]
}

/***********************************************
  Private Artifact Registry DNS Zone & records.
 ***********************************************/

module "base_pkg_dev" {
  count       = var.enable_dns_zone_pkg_dev ? 1 : 0
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.1"
  project_id  = var.project_id
  type        = "private"
  name        = "dz-${var.environment_code}-shared-base-pkg-dev"
  domain      = "pkg.dev."
  description = "Private DNS zone to configure pkg.dev"

  private_visibility_config_networks = [
    module.main.network_self_link
  ]

  recordsets = [
    {
      name    = "*"
      type    = "CNAME"
      ttl     = 300
      records = ["pkg.dev."]
    },
    {
      name    = ""
      type    = "A"
      ttl     = 300
      records = local.private_googleapis_cidr_hosts_list
    },
  ]
}

/******************************************
 Creates DNS Peering to DNS HUB
*****************************************/
module "peering_zone" {
  count       = var.enable_dns_peering ? 1 : 0
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.1"
  project_id  = var.project_id
  type        = "peering"
  name        = "dz-${var.environment_code}-shared-base-to-dns-hub"
  domain      = var.domain
  description = "Private DNS peering zone."

  private_visibility_config_networks = [
    module.main.network_self_link
  ]
  target_network = data.google_compute_network.vpc_dns_hub.self_link
}
