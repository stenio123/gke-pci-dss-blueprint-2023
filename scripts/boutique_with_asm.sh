# Deploy Online Boutique - no Mesh
gcloud container clusters get-credentials gke-in-scope \
    --project=service-in-scope-7c3c \
    --region=us-east1

kubectl config set-context gke-in-scope

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo


kubectl apply -f ./release/kubernetes-manifests.yaml

# Install ASM (cant use ASM tf module because it requires "servicemesh" feature enabled, and this is not available in the tf gke resource or module, so might as well use script for everything)
# https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/v24.1.0/modules/asm#usage
gcloud container clusters get-credentials gke-in-scope \
    --project=service-in-scope-7c3c \
    --region=us-east1

kubectl config set-context gke-in-scope

gcloud container fleet mesh enable --project service-in-scope-7c3c

gcloud container fleet memberships register gke-in-scope-membership \
  --gke-cluster=us-east1/gke-in-scope \
  --enable-workload-identity \
  --project service-in-scope-7c3c

  gcloud container fleet mesh update \
  --management automatic \
  --memberships gke-in-scope-membership \
  --project service-in-scope-7c3c

  gcloud container fleet mesh describe --project service-in-scope-7c3c

## Demo
    git clone https://github.com/GoogleCloudPlatform/anthos-service-mesh-packages.git

# Remove to avoid error
# error: resource mapping not found for name: "istio-ingressgateway" namespace: "" from "anthos-service-mesh-packages/samples/gateways/istio-ingressgateway/autoscaling-v2beta1.yaml": no matches for kind "HorizontalPodAutoscaler" in version "autoscaling/v2beta1"
rm anthos-service-mesh-packages/samples/gateways/istio-ingressgateway/autoscaling-v2beta1.yaml

kubectl create namespace gateway-namespace

kubectl label namespace gateway-namespace istio-injection=enabled istio.io/rev-

kubectl apply -n gateway-namespace \
-f anthos-service-mesh-packages/samples/gateways/istio-ingressgateway

kubectl apply -f \
anthos-service-mesh-packages/samples/online-boutique/kubernetes-manifests/namespaces

for ns in ad cart checkout currency email frontend loadgenerator payment product-catalog recommendation shipping; do
    kubectl label namespace $ns istio-injection=enabled istio.io/rev-
done;

kubectl apply -f \
anthos-service-mesh-packages/samples/online-boutique/kubernetes-manifests/deployments

kubectl apply -f \
anthos-service-mesh-packages/samples/online-boutique/kubernetes-manifests/services

kubectl apply -f \
anthos-service-mesh-packages/samples/online-boutique/istio-manifests/allow-egress-googleapis.yaml

kubectl apply -f \
anthos-service-mesh-packages/samples/online-boutique/istio-manifests/frontend-gateway.yaml

kubectl get service istio-ingressgateway \
-n gateway-namespace




