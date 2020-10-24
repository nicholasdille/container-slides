#!/bin/bash

# Create app
kubectl apply -f podinfo.yaml
kubectl get gitrepository podinfo
kubectl get gitrepository podinfo-dev

# Wait for deployment
watch kubectl get pods -A

# Check browser
kubectl port-forward service/podinfo 9898:9898
# http://localhost:9898