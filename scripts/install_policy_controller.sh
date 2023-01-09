  gcloud beta container fleet config-management enable
  
  gcloud beta container fleet config-management apply \
      --membership=gke-in-scope-membership \
      --config=apply-spec.yaml \
      --project=service-in-scope-7c3c

# Might take a while to provision resources and install