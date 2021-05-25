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
      team                  = "kube"
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
      team                  = "kube"
      subnet_ip             = "10.1.80.0/21"
      enable_flow_logs      = true
      enable_private_access = true
    }
  ]

}