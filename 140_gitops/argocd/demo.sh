#!/bin/bash

# Recommended layout
#
#                                 |
#   watch kubectl get app -A      |
#                                 |
# --------------------------------+  watch kubectl get pods -A
#                                 |
#   kubectl apply -f podinfo.yaml |
#                                 |

# Create port forwarding
kubectl port-forward --namespace argocd svc/argocd-server 8080:443

# Fetch authentication info
PASSWORD=$(
    kubectl --namespace argocd get pods --selector app.kubernetes.io/name=argocd-server --output name | \
        cut -d'/' -f 2
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

# Check browser
kubectl port-forward service/podinfo 9898:9898
# http://localhost:9898