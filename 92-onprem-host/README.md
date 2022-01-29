# Onprem connectivity tests

Tested the onprem connectivity for us-central1 region

onprem vm was launched using this repo

dev vm was launched using 05-app-infra

hub vm was launched manually

## Tests

- ping dev vm private ip from onprem vm and vice versa
- ping hub vm private ip from onprem vm and vice versa
- ```gcloud compute instances list``` on onprem vm
- ping ```host1.onprem.budita.dev``` from dev vm
- ping ```host1.onprem.budita.dev``` from hub vm