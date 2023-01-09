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