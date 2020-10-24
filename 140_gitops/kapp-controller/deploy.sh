#!/bin/bash

# Create cluster
kind create cluster --name kapp --config kind.yaml

# If the cluster is running on a remote Docker host
ssh -fNL 127.0.0.1:6443:127.0.0.1:6443 docker-hcloud

# Wait for cluster node to become ready
echo -n "Waiting for nodes to be ready..."
while kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.conditions[?(@.reason=="KubeletReady")].status}{"\n"}{end}' | grep -qE "\sFalse$"; do
    echo -n "."
    sleep 5
done
echo " done."

# Deploy kapp-controller
kubectl apply -f https://github.com/k14s/kapp-controller/releases/latest/download/release.yml

# Wait for pods to become ready
kubectl -n kapp-controller rollout status deployment kapp-controller

# RBAC
kubectl apply -f sa.yaml