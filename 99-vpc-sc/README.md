# VPC-SC

In 01-org, an aggregated logsink at org level is created to send _only_ the vpc-sc violations to the central logging project.

Sample sql to query the dataset:

```
SELECT resource.type, resource.labels.project_id,resource.labels.service,
    resource.labels.method,protopayload_auditlog.authenticationInfo.principalEmail,
    protopayload_auditlog.metadataJson		

FROM `prj-c-logging-8083.audit_logs.cloudaudit_googleapis_com_policy`

ORDER BY timestamp DESC
```