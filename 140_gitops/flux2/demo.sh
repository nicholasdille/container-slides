#!/bin/bash

# Create app
kubectl apply -f podinfo.yaml
kubectl get gitrepository podinfo
kubectl get kustomization podinfo-dev

# Wait for deployment
watch kubectl get pods -A

# Check backend in browser
kubectl -n dev port-forward service/backend 9898:9898
# http://localhost:9898

# Check frontend in browser
kubectl -n dev port-forward service/frontend 8080:80
# http://localhost:8080