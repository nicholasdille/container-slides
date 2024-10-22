#!/bin/bash

uniget install kind kubectl kubectl-oidc-login

# https://gitlab.com/k8s-oidc-demo
read -s -p "GitLab App ID: " GL_APP_ID
export GL_APP_ID

# Inject GL_APP_ID into kind.yaml

cat kind.yaml \
| envsubst \
| kind create cluster \
    --name oidc \
    --config - \
    --kubeconfig ./kubeconfig \
    --wait 5m
