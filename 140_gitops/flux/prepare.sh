#!/bin/bash

# Add completion for fluxctl
source <(fluxctl completion bash)

# Create cluster
kind create cluster

# Wait for fork to be created
echo Please create a fork of https://github.com/nicholasdille/flux-demo-template into https://github.com/nicholasdille/flux-demo
pause

# Create kustomize control file
cat > kustomization.yaml <<EOF
namespace: flux
bases:
  - github.com/fluxcd/flux/deploy?ref=v1.19.0
patchesStrategicMerge:
  - patch.yaml
EOF

# Create patch for personalized deployment
cat > patch.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flux
  namespace: flux
spec:
  template:
    spec:
      containers:
        - name: flux
          args:
            - --manifest-generation=true
            - --memcached-hostname=memcached.flux
            - --memcached-service=
            - --ssh-keygen-dir=/var/fluxd/keygen
            - --git-branch=master
            - --git-path=namespaces,workloads
            - --git-user=nicholasdille
            - --git-email=nicholasdille@users.noreply.github.com
            - --git-url=git@github.com:nicholasdille/flux-demo
EOF

# Deploy flux
kubectl apply -k .

# Wait for deployment to finish
kubectl -n flux rollout status deployment/flux

# Display identity
export FLUX_FORWARD_NAMESPACE=flux
fluxctl identity

# Wait for permissions to be set
echo Please add the identity as a deployment key with write access
pause
