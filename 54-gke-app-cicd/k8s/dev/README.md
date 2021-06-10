# Simple Python App

## External access over the Internet
The beta-private-cluster terraform module creates an external tcp loadbalancer or istio ingress gateway by default. Later, istio ingress gateway is configured with istio-gateway.yaml and istio-vsvc.yaml.

## External access from within the VPC
To provision internal tcp load balancer, we need to configure istio operator with the required annotation otherwise istio will provision external tcp load balancer or istio ingress gateway. We need to apply istio-operator yaml. This is not covered here.