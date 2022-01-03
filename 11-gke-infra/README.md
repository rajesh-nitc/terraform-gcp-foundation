# GKE cluster with ACM in a Shared VPC

**Guideline_1**: Google recommends ASM for production scenarios.

**Actual_1**: we are using Istio addon which comes with default options. For e.g. external tcp network load balancer.

**Guideline_2**: Register the cluster with gke hub

**Actual_2**: we are using acm as a standalone feature

**Guideline_3**: Private cluster shoule be accessible from bastion host only

**Actual_3**: we have allowed external access to the gke control plane to test the cicd.