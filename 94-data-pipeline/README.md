# Dataflow Sample Pipelines in Shared VPC

## Batch pipeline using Python

Prerequisites:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com

gsutil cp data/names_data.csv gs://bkt-d-data-landing-raw-data
```

Run job:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com

python3 csv_line_to_bq_row.py \
  --input=gs://bkt-d-data-landing-raw-data/names_data.csv \
  --output=prj-data-d-dwh-3f33:bq_raw_dataset.names1 \
  --temp_location=gs://bkt-d-data-dataflow-temp \
  --runner=DataflowRunner \
  --project=prj-data-d-transformation-4f2b \
  --region=us-central1 \
  --no_use_public_ips \
  --subnetwork=https://www.googleapis.com/compute/v1/projects/prj-d-shared-base-21a3/regions/us-central1/subnetworks/sb-d-shared-base-us-central1-data \
  --service_account_email=project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com
```
## Batch pipeline using Templates

Prerequisites:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com

gsutil cp data/names_data.csv gs://bkt-d-data-landing-raw-data
gsutil cp schema/names_schema.json gs://bkt-d-data-landing-data-schema
gsutil cp udf/names_udf.js gs://bkt-d-data-landing-data-schema
```

Run job:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com

gcloud dataflow jobs run first-batch-template-job \
    --gcs-location gs://dataflow-templates/latest/GCS_Text_to_BigQuery \
    --project prj-data-d-transformation-4f2b \
    --region us-central1 \
    --disable-public-ips \
    --network vpc-d-shared-base-spoke \
    --subnetwork https://www.googleapis.com/compute/v1/projects/prj-d-shared-base-21a3/regions/us-central1/subnetworks/sb-d-shared-base-us-central1-data \
    --staging-location gs://bkt-d-data-dataflow-temp \
    --service-account-email project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com \
    --parameters \
javascriptTextTransformFunctionName=transform_batch_data,\
JSONPath=gs://bkt-d-data-landing-data-schema/names_schema.json,\
javascriptTextTransformGcsPath=gs://bkt-d-data-landing-data-schema/names_udf.js,\
inputFilePattern=gs://bkt-d-data-landing-raw-data/names_data.csv,\
outputTable=prj-data-d-dwh-3f33:bq_raw_dataset.names2,\
bigQueryLoadingTemporaryDirectory=gs://bkt-d-data-dataflow-temp
```

## Streaming pipeline using Templates

Prerequisites:
```
gcloud config unset auth/impersonate_service_account

bq mk -t --description "This is US baby names table" prj-data-d-dwh-3f33:bq_raw_dataset.names3 state:STRING,gender:STRING,year:DATE,name:STRING,number:INTEGER,created_date:STRING

gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com

gsutil cp udf/names_udf.js gs://bkt-d-data-landing-data-schema
```

Publish:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com

for i in {0..4} 
do 
  gcloud pubsub topics publish projects/prj-data-d-landing-0816/topics/tp-d-data-landing --message="{\"state\": \"AL\", \"gender\": \"F\", \"year\": \"2015\",\"name\": \"Dorothy\",\"number\": \"5\",\"created_date\": \"11/28/2016\"}"
done
```

Run job:
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com

gcloud dataflow jobs run first-streaming-template-job \
    --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery \
    --project prj-data-d-transformation-4f2b \
    --region us-central1 \
    --disable-public-ips \
    --network vpc-d-shared-base-spoke \
    --subnetwork https://www.googleapis.com/compute/v1/projects/prj-d-shared-base-21a3/regions/us-central1/subnetworks/sb-d-shared-base-us-central1-data \
    --staging-location gs://bkt-d-data-dataflow-temp \
    --service-account-email project-service-account@prj-data-d-transformation-4f2b.iam.gserviceaccount.com \
    --parameters \
javascriptTextTransformFunctionName=transform_streaming_data,\
javascriptTextTransformGcsPath=gs://bkt-d-data-landing-data-schema/names_udf.js,\
inputSubscription=projects/prj-data-d-landing-0816/subscriptions/sub-dataflow,\
outputTableSpec=prj-data-d-dwh-3f33:bq_raw_dataset.names3
```