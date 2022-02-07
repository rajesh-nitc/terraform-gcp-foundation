# Dataflow Sample Pipelines in Shared VPC

## Batch pipeline using Templates

### Prerequisites
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com

gsutil cp data/names_data.csv gs://bkt-d-data-landing-raw-data
gsutil cp schema/names_schema.json gs://bkt-d-data-landing-data-schema
gsutil cp udf/names_udf.js gs://bkt-d-data-landing-data-schema
```

### Run job
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-loading-82c5.iam.gserviceaccount.com

gcloud dataflow jobs run first-batch-job \
    --gcs-location gs://dataflow-templates/latest/GCS_Text_to_BigQuery \
    --project prj-data-d-loading-82c5 \
    --region us-central1 \
    --disable-public-ips \
    --network vpc-d-shared-base-spoke \
    --subnetwork https://www.googleapis.com/compute/v1/projects/prj-d-shared-base-21a3/regions/us-central1/subnetworks/sb-d-shared-base-us-central1-data \
    --staging-location gs://bkt-d-data-dataflow-temp \
    --service-account-email sa-dataflow-worker@prj-data-d-loading-82c5.iam.gserviceaccount.com \
    --parameters \
javascriptTextTransformFunctionName=transform_batch_data,\
JSONPath=gs://bkt-d-data-landing-data-schema/names_schema.json,\
javascriptTextTransformGcsPath=gs://bkt-d-data-landing-data-schema/names_udf.js,\
inputFilePattern=gs://bkt-d-data-landing-raw-data/names_data.csv,\
outputTable=prj-data-d-lake-l0-ffe8:bq_dataset_l0.names5,\
bigQueryLoadingTemporaryDirectory=gs://bkt-d-data-dataflow-temp
```

## Streaming pipeline using Templates

### Prerequisites
```
gcloud config unset auth/impersonate_service_account

bq mk -t --description "This is US baby names table" prj-data-d-lake-l0-ffe8:bq_dataset_l0.names6 state:STRING,gender:STRING,year:DATE,name:STRING,number:INTEGER,created_date:STRING

gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com

gsutil cp udf/names_udf.js gs://bkt-d-data-landing-data-schema
```

### Publish
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-landing-0816.iam.gserviceaccount.com

for i in {0..4} 
do 
  gcloud pubsub topics publish projects/prj-data-d-landing-0816/topics/tp-d-data-landing --message="{\"state\": \"AL\", \"gender\": \"F\", \"year\": \"2015\",\"name\": \"Dorothy\",\"number\": \"5\",\"created_date\": \"11/28/2016\"}"
done
```

### Run job
```
gcloud config set auth/impersonate_service_account project-service-account@prj-data-d-loading-82c5.iam.gserviceaccount.com

gcloud dataflow jobs run first-streaming-template-job \
    --gcs-location gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery \
    --project prj-data-d-loading-82c5 \
    --region us-central1 \
    --disable-public-ips \
    --network vpc-d-shared-base-spoke \
    --subnetwork https://www.googleapis.com/compute/v1/projects/prj-d-shared-base-21a3/regions/us-central1/subnetworks/sb-d-shared-base-us-central1-data \
    --staging-location gs://bkt-d-data-dataflow-temp \
    --service-account-email sa-dataflow-worker@prj-data-d-loading-82c5.iam.gserviceaccount.com \
    --parameters \
javascriptTextTransformFunctionName=transform_streaming_data,\
javascriptTextTransformGcsPath=gs://bkt-d-data-landing-data-schema/names_udf.js,\
inputSubscription=projects/prj-data-d-landing-0816/subscriptions/sub-dataflow,\
outputTableSpec=prj-data-d-lake-l0-ffe8:bq_dataset_l0.names6
```