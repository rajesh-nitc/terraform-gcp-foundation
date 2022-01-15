module "vpn_net_hub_to_onprem_cr1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 2.1.0"
  project_id       = var.net_hub_project_id
  region           = var.default_region1
  network          = var.net_hub_self_link
  name             = "net-hub-to-onprem-${var.default_region1}-cr1"
  peer_gcp_gateway = module.vpn_onprem_to_net_hub_cr1.self_link
  router_asn       = 64515
  router_advertise_config = {
    groups = ["ALL_SUBNETS"]
    ip_ranges = {
      (local.private_googleapis_cidr)     = "private-googleapis",
      (var.gcp_default_region1_dev_range) = "gcp-us-central1-dev-address-space"
    }
    mode = "CUSTOM"
  }

  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.1"
        asn     = 64516
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.2/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = ""
    }
  }
}

module "vpn_onprem_to_net_hub_cr1" {
  source           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version          = "~> 2.1.0"
  project_id       = var.project_id
  region           = var.default_region1
  network          = module.main.network_self_link
  name             = "onprem-to-net-hub-${var.default_region1}-cr1"
  router_asn       = 64516
  peer_gcp_gateway = module.vpn_net_hub_to_onprem_cr1.self_link
  tunnels = {
    remote-0 = {
      bgp_peer = {
        address = "169.254.1.2"
        asn     = 64515
      }
      bgp_peer_options                = null
      bgp_session_range               = "169.254.1.1/30"
      ike_version                     = 2
      vpn_gateway_interface           = 0
      peer_external_gateway_interface = null
      shared_secret                   = module.vpn_net_hub_to_onprem_cr1.random_secret
    }
  }
}