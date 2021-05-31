subnets = {
  "us-central1" = [
    {
      team                  = "bu1"
      subnet_ip             = "10.0.64.0/21"
      enable_flow_logs      = true
      enable_private_access = true

    },
    {
      team                  = "data"
      subnet_ip             = "10.0.72.0/21"
      enable_flow_logs      = true
      enable_private_access = true
    },
    {
      team                  = "gke"
      subnet_ip             = "10.0.80.0/21"
      enable_flow_logs      = true
      enable_private_access = true
    }
  ]

  "us-west1" = [
    {
      team                  = "bu1"
      subnet_ip             = "10.1.64.0/21"
      enable_flow_logs      = true
      enable_private_access = true
    },
    {
      team                  = "data"
      subnet_ip             = "10.1.72.0/21"
      enable_flow_logs      = true
      enable_private_access = true
    },
    {
      team                  = "gke"
      subnet_ip             = "10.1.80.0/21"
      enable_flow_logs      = true
      enable_private_access = true
    }
  ]

}

budita_cluster_uscentral1_cluster_ip_range_pods      = "100.64.64.0/21"
budita_cluster_uscentral1_cluster_ip_range_services  = "100.64.72.0/21"
budita_cluster_uscentral1_cluster_endpoint_for_nodes = "100.64.80.0/28"
budita_cluster_uscentral1_cluster_network_tag        = "gke-budita-d-us-central1"