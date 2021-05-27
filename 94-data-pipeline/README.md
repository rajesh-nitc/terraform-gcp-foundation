# Dataflow Sample Pipeline in Shared VPC

Create bigquery table person with schema ```name:STRING,surname:STRING,timestamp:TIMESTAMP```

Publish:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com

for i in {0..4} 
do 
  gcloud pubsub topics publish projects/prj-data-d-landing-0816/topics/tp-d-data-landing --message="{\"name\": \"Rajesh\", \"surname\": \"Gupta\", \"timestamp\": \"$(date +%s)\"}"
done

```

Run job:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com

gcloud dataflow jobs run first-dataflow-job \
    --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery \
    --project prj-data-d-transformation-4f2b \
    --region us-central1 \
    --disable-public-ips \
    --network vpc-d-shared-base \
    --subnetwork https://www.googleapis.com/compute/v1/projects/prj-d-shared-base-21a3/regions/us-central1/subnetworks/sb-d-shared-base-us-central1-data \
    --staging-location gs://bkt-d-data-tfn-temp \
    --service-account-email project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com \
    --parameters inputSubscription=projects/prj-data-d-landing-0816/subscriptions/sub-dataflow,outputTableSpec=prj-data-d-dwh-3f33:bq_raw_dataset.person
```