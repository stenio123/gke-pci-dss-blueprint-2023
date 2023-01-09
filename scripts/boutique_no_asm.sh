# Deploy Online Boutique - no Mesh
gcloud container clusters get-credentials gke-in-scope \
    --project=service-in-scope-7c3c \
    --region=us-east1

kubectl config set-context gke-in-scope

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo


kubectl apply -f ./release/kubernetes-manifests.yaml