#!/bin/bash
set -o errexit -o pipefail

cd ~/container-slides/180_observability/000_infrastructure/004_kubernetes
kind delete cluster
kind create cluster --config=kind.yaml
