resource "google_dns_policy" "default_policy" {
  project                   = var.project_id
  name                      = "dp-onprem-default-policy"
  enable_inbound_forwarding = true
  enable_logging            = false
  networks {
    network_url = module.main.network_self_link
  }
}

# Resolve private.googleapis.com and restricted.googleapis on prem
module "private_googleapis" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.1"
  project_id  = var.project_id
  type        = "private"
  name        = "dz-google-apis"
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
      records = ["private.googleapis.com."]
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
  ]
}

module "private_onprem" {
  source      = "terraform-google-modules/cloud-dns/google"
  version     = "~> 3.1"
  project_id  = var.project_id
  type        = "private"
  name        = "dz-onprem"
  domain      = var.domain
  description = "Private DNS zone"

  private_visibility_config_networks = [
    module.main.network_self_link
  ]

  recordsets = [
    {
      name    = var.hostname
      type    = "A"
      ttl     = 300
      records = [var.private_ip]
    },
  ]
}