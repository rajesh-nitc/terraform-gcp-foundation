# Onprem connectivity

Tested the onprem connectivity with dev sharedvpc for us-central1 region

Spare vm was launched using 05-app-infra in dev sharedvpc

Onprem vm was launched using 92-onprem-host

## Tests

- ping spare vm private ip from onprem vm and vice versa
- run ```gcloud compute instances list``` on onprem vm
- ping ```host1.onprem.budita.dev``` from spare vm