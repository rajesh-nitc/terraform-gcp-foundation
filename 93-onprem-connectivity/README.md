# Onprem connectivity

Tested the onprem connectivity with dev sharedvpc for us-central1 region

Spare vm was launched using 05-app-infra in dev sharedvpc

Onprem vm was launched using onprem-host dir. If the vm is successfully launched, it means private google access is working

## Tests

- ping spare vm internal ip from onprem vm and vice versa
- ping ```host1.onprem.budita.dev``` from spare vm