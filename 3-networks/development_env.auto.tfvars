subnets = [
  {
    team                  = "bu1"
    subnet_ip             = "10.0.64.0/21"
    region                = "us-central1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "data"
    subnet_ip             = "10.0.72.0/21"
    region                = "us-central1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "gke"
    subnet_ip             = "10.0.80.0/21"
    region                = "us-central1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range = {
      pod = "100.64.64.0/21"
      svc = "100.64.72.0/21"
    }
  },
  {
    team                  = "bu1"
    subnet_ip             = "10.1.64.0/21"
    region                = "us-west1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "data"
    subnet_ip             = "10.1.72.0/21"
    region                = "us-west1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
  {
    team                  = "gke"
    subnet_ip             = "10.1.80.0/21"
    region                = "us-west1"
    enable_flow_logs      = false
    enable_private_access = true
    secondary_ip_range    = {}
  },
]

nat_enabled = false # nat is required by acm git-sync container in git-importer pod

budita_cluster_uscentral1_cluster_endpoint_for_nodes = "100.64.80.0/28"
budita_cluster_uscentral1_cluster_network_tag        = "gke-budita-d-us-central1"