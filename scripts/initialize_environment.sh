gcloud config set project service-in-scope-7c3c

gcloud container clusters get-credentials gke-in-scope \
    --project=service-in-scope-7c3c \
    --region=us-east1

kubectl config set-context gke-in-scope
