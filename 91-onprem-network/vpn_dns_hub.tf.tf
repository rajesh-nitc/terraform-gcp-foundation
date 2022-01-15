module "vpn_dns_hub_to_onprem_cr1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 2.1.0"
  project_id       = var.dns_hub_project_id
  region           = var.default_region1
  network          = var.dns_hub_self_link
  name             = "dns-hub-to-onprem-${var.default_region1}-cr1"
  peer_gcp_gateway = module.vpn_onprem_to_dns_hub_cr1.self_link
  router_asn       = 64517
  router_advertise_config = {
    groups = ["ALL_SUBNETS"]
    ip_ranges = {
      (local.dns_proxy_cidr) = "dns-proxy",
    }
    mode = "CUSTOM"
  }

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.2.1"
        asn     = 64518
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
  }
}

module "vpn_onprem_to_dns_hub_cr1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 2.1.0"
  project_id       = var.project_id
  region           = var.default_region1
  network          = module.main.network_self_link
  name             = "onprem-to-dns-hub-${var.default_region1}-cr1"
  router_asn       = 64518
  peer_gcp_gateway = module.vpn_dns_hub_to_onprem_cr1.self_link
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.2.2"
        asn     = 64517
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.2.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn_dns_hub_to_onprem_cr1.random_secret
    }
  }
}