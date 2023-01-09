# GKE PCI DSS Blueprint
Created based on the original architecture.

Anthos Service Mesh is installed as an example, check links in the docs to enable/disable mTLS which will break/fix online boutique since not using TLS. Service Mesh policies is outside the scope of this demo, but in summary you would be able to specify if one service is allowed to communicate with the other, and vice-versa. This allows ensuring one-way communication and greater security by disabling all communications by default, and setting them explicitly.

Anthos Config Manager has two Features
Policy Manager: we show an example of enabling the PCI policy bundle
Config Sync: it is a good practice to lower the burden of maintaining and updating cluster configurations, while ensuring consistency, however it is outside the scope of this demo. For more information on GitOps https://cloud.google.com/kubernetes-engine/docs/tutorials/gitops-cloud-build

# Deploy Infrastructure
- Update terraform.tfvars:
```
org_id = "635377931671"
folder_id = "807659693139"
billing_account = "01B15E-617D1D-FC4231"
domain = "example-stenio.com."
```
- terraform init; terraform apply

## Test Without ASM:
- Update the scripts changing "service-in-scope-7c3c" for the name of the in-scope project
- execute scripts/boutique_no_asm.sh
- it will fail
- create a firewall rule to open all 0.0.0.0/0
- it works
- TODO - FIXME!

# Install ASM
## Note
As mentioned in the code comment, ASM module is not being used because it requires "anthos_mesh" to be enabled. This can be done through the UI or console, however is not available in the tf resource (consequently, also in the gke module). Therefore decided to script everything

- Update the scripts changing "service-in-scope-7c3c" for the name of the in-scope project
- execute scripts/install_anthos_service_mesh.sh

## Test with ASM
- Update the scripts changing "service-in-scope-7c3c" for the name of the in-scope project
- execute scripts/boutique_with_asm.sh
- execute scripts/boutique_with_asm.sh
- TODO add sleep to give time for namespace to be created

# Install Policy Controller
WIP