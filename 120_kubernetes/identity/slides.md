## Workload Identity

IAM Roles for Service Accounts (IRSA) https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html

https://azure.github.io/azure-workload-identity/docs/

https://cloud.google.com/config-connector/docs/overview?hl=de


### Token Review

```shell
#kubectl create sa bar
TOKEN="$(kubectl create token bar)"
cat <<EOF | kubectl apply -f - -o yaml
kind: TokenReview
apiVersion: authentication.k8s.io/v1
metadata:
  name: test
spec:
  token: ${TOKEN}
EOF
```