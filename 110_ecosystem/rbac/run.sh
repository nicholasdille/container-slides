#!/bin/bash

set -o errexit

kind create cluster

while test "$(kubectl get node kind-control-plane -o json | jq --raw-output '.status.conditions[] | select(.reason == "KubeletReady") | select(.type == "Ready") | .status')" != "True"; do
    sleep 5
done

kubectl apply -f cluster-admin.yaml
kubectl apply -f cluster-reader.yaml
kubectl apply -f test-namespace.yaml
kubectl apply -f test-admin.yaml
kubectl apply -f test-reader.yaml

kubectl --context=cluster-reader --as=system:serviceaccount:default:cluster-admin get all -A
kubectl --context=test-reader --as=system:serviceaccounts:test:admin get cm

kind delete cluster
