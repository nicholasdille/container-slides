#!/bin/bash

#                                 |
#   watch kubectl get app -A      |
#                                 |
# --------------------------------+  watch kubectl get pods -A
#                                 |
#   kubectl apply -f podinfo.yaml |
#                                 |

# Create port forwarding
kubectl port-forward svc/argocd-server --namespace argocd 8080:443 --address=0.0.0.0

# Fetch authentication info
PASSWORD=$(
    kubectl -n argocd get secrets argocd-initial-admin-secret -o json \
    | jq -r .data.password | base64 -d
)
echo Access https://localhost:8080 using admin:${PASSWORD}

# Login to ArgoCD
argocd login --insecure --username admin --password ${PASSWORD} localhost:8080

# Create app
kubectl apply -f podinfo.yaml
argocd app sync podinfo

# Check app
kubectl get app -A

# Wait for deployment
watch kubectl get pods -A

# Check app
kubectl get app -A

# Update to version 6.5.2