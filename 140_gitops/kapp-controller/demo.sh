#!/bin/bash

# Deploy app
kubectl apply -f podinfo.yaml

# Check app
kubectl get app -A

# Wait for deployment
watch kubectl get pods -A

# Check app
kubectl get app -A

# Check browser
kubectl port-forward service/podinfo 9898:9898
# http://localhost:9898