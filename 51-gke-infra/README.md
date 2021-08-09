# GKE cluster with ACM in a Shared VPC

**Guideline_1**: Google recommends ASM for production scenarios.

**Actual_1**: with Istio addon, istio will be installed with default options. For e.g. external tcp network load balancer. If customization is needed, either we install istio i.e. not as an addon or use asm. In our case, we are using the addon.
