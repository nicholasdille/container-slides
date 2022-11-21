#!/bin/bsah
set -o errexit

docker-setup --tools=docker,docker-compose,buildx,kind,kubectl,helm,kubeletctl install

# cluster
kind create cluster --config kind.yaml

# ingress
curl --silent --location https://github.com/kubernetes/ingress-nginx/raw/main/deploy/static/provider/kind/deploy.yaml | kubectl apply -f -
kubectl apply -f ingress.yaml

# prometheus-operator
curl -sL https://github.com/prometheus-operator/prometheus-operator/releases/download/v0.60.1/bundle.yaml | kubectl create -f -
kubectl apply -f prometheus.yaml

# metrics server (https://github.com/kubernetes-sigs/kind/issues/398)
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
helm upgrade --install --set args={--kubelet-insecure-tls} metrics-server metrics-server/metrics-server --namespace kube-system

# node-exporter
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm --namespace kube-system upgrade --install node-exporter prometheus-community/prometheus-node-exporter --values values-node-exporter.yaml

# kube-state-metrics
helm --namespace kube-system upgrade --install kube-state-metrics prometheus-community/kube-state-metrics --values values-kube-state-metrics.yaml

# pushgateway
helm --namespace kube-system upgrade --install pushgateway prometheus-community/prometheus-pushgateway --values values-pushgateway.yaml

# monitors
kubectl apply -f monitors.yaml
docker exec -it kind-control-plane sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/' /etc/kubernetes/manifests/kube-scheduler.yaml
docker exec -it kind-control-plane sed -i 's/--bind-address=127.0.0.1/--bind-address=0.0.0.0/' /etc/kubernetes/manifests/kube-controller-manager.yaml
kubectl -n kube-system get cm kube-proxy -o yaml | sed 's/metricsBindAddress: ""/metricsBindAddress: "0.0.0.0:10249"/' | kubectl -n kube-system apply -f -
kubectl -n kube-system get pod -l k8s-app=kube-proxy -o name | xargs -I{} kubectl -n kube-system delete {}

# grafana
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm --namespace kube-system upgrade --install grafana grafana/grafana --values values-grafana.yaml
kubectl -n kube-system get secret grafana -o json | jq -r '.data."admin-password"' | base64 -d

# postgresql
helm repo add bitnami https://charts.bitnami.com/bitnami
helm upgrade --install postgresql bitnami/postgresql --values values-postgresql.yaml

# blackbox exporter
helm upgrade --install blackbox-exporter prometheus-community/prometheus-blackbox-exporter --values values-blackbox-exporter.yaml

# JSON exporter
helm upgrade --install json-exporter prometheus-community/prometheus-json-exporter --values values-json-exporter.yaml

# app
curl -sL https://github.com/brancz/prometheus-example-app/raw/master/manifests/deployment.yaml | kubectl apply -f -
curl -sL https://github.com/brancz/prometheus-example-app/raw/master/manifests/pod-monitor.yaml | kubectl apply -f -