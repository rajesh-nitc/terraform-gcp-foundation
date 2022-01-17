# Error 400: The resource vpn-onprem-to-net-hub-us-central1-cr1' is not ready, resourceNotReady
# terraform apply again will work
module "vpn_onprem_to_dns_hub_cr1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 2.1.0"
  project_id       = var.project_id
  region           = var.default_region1
  network          = module.main.network_self_link
  name             = "onprem-to-dns-hub-${var.default_region1}-cr1"
  router_asn       = var.router_asn["onprem"]
  router_name      = module.vpn_onprem_to_net_hub_cr1.router_name
  peer_gcp_gateway = module.vpn_dns_hub_to_onprem_cr1.self_link
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = cidrhost(var.bgp_session_range[var.default_region1]["dns-hub"], 2)
        asn     = var.router_asn["dns-hub"]
      }
      bgp_peer_options                = null
      bgp_session_range               = format("%s/%s", cidrhost(var.bgp_session_range[var.default_region1]["dns-hub"], 1), "30")
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn_dns_hub_to_onprem_cr1.random_secret
    }
  }
}

module "vpn_dns_hub_to_onprem_cr1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 2.1.0"
  project_id       = var.dns_hub_project_id
  region           = var.default_region1
  network          = var.dns_hub_self_link
  name             = "dns-hub-to-onprem-${var.default_region1}-cr1"
  peer_gcp_gateway = module.vpn_onprem_to_dns_hub_cr1.self_link
  router_asn       = var.router_asn["dns-hub"]
  router_advertise_config = {
    groups = ["ALL_SUBNETS"]
    ip_ranges = {
      (local.dns_forwarders_cidr) = "dns-forwarders",
    }
    mode = "CUSTOM"
  }

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = cidrhost(var.bgp_session_range[var.default_region1]["dns-hub"], 1)
        asn     = var.router_asn["onprem"]
      }
      bgp_peer_options                = null
      bgp_session_range               = format("%s/%s", cidrhost(var.bgp_session_range[var.default_region1]["dns-hub"], 2), "30")
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
  }
}

