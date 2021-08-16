import os
from flask import Flask
from google.cloud import storage

app = Flask(__name__)


@app.route('/')
def hello_world():
    target = os.environ.get('TARGET', 'World')
    return "hello {}".format(target)


@app.route('/health')
def health():
    return "Frontend service is healthy"


@app.route('/buckets')
def list_buckets():
    project_id = os.environ.get('PROJECT_ID', 'prj-gke-d-clusters-3c96')
    storage_client = storage.Client(project=project_id)
    buckets = storage_client.list_buckets()
    bucket_names = []
    for bucket in buckets:
        bucket_names.append(bucket.name)
    return """
    You have {} buckets. This means that workload identity is working and ... 
    the egress to metadata server and to private google apis via istio is working""".format(str(len(bucket_names)))

if __name__ == "__main__":
    app.run(debug=True, host='0.0.0.0', port=int(os.environ.get('PORT', 8080)))
