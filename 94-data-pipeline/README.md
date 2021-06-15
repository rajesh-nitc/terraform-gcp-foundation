# Dataflow Sample Pipelines in Shared VPC

## Batch pipeline

Prerequisites:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com

gsutil cp usa_names.csv gs://bkt-d-data-landing-raw-data
# Example data: KS,F,1923,Dorothy,654,11/28/2016
```

Run job:
```
python3 data_ingestion.py \
  --input=gs://bkt-d-data-landing-raw-data/usa_names.csv \
  --output=prj-data-d-dwh-3f33:bq_raw_dataset.sample_data \
  --temp_location=gs://bkt-d-data-tfn-temp \
  --runner=DataflowRunner \
  --project=prj-data-d-transformation-4f2b \
  --region=us-central1 \
  --no_use_public_ips \
  --subnetwork=https://www.googleapis.com/compute/v1/projects/prj-d-shared-base-21a3/regions/us-central1/subnetworks/sb-d-shared-base-us-central1-data \
  --service_account_email=project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com
```

## Streaming pipeline

Prerequisites:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-dwh-3f33.iam.gserviceaccount.com

bq mk -t --description "This is a Test Person table" prj-data-d-dwh-3f33:bq_raw_dataset.person name:STRING,surname:STRING,timestamp:TIMESTAMP
```

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
    --network vpc-d-shared-base-spoke \
    --subnetwork https://www.googleapis.com/compute/v1/projects/prj-d-shared-base-21a3/regions/us-central1/subnetworks/sb-d-shared-base-us-central1-data \
    --staging-location gs://bkt-d-data-tfn-temp \
    --service-account-email project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com \
    --parameters inputSubscription=projects/prj-data-d-landing-0816/subscriptions/sub-dataflow,outputTableSpec=prj-data-d-dwh-3f33:bq_raw_dataset.person
```