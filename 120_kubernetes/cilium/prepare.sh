#!/bin/bash
set -o errexit

docker-setup --tools=docker,buildx,docker-compose,kind,helm,kubectl,cilium install

kind create cluster --config kind.yaml

sysctl fs.inotify.max_user_instances=1280
sysctl fs.inotify.max_user_watches=655360

helm repo add cilium https://helm.cilium.io/
helm upgrade --install cilium cilium/cilium \
   --namespace cilium-system \
   --create-namespace \
   --set nodeinit.enabled=true \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set ipam.mode=kubernetes \
   --set hubble.enabled=true \
   --set hubble.listenAddress=":4244" \
   --set hubble.relay.enabled=true \
   --set hubble.ui.enabled=true

curl --silent --location https://github.com/kubernetes/ingress-nginx/raw/main/deploy/static/provider/kind/deploy.yaml \
| kubectl apply -f -

helm upgrade --install cilium cilium/cilium \
   --namespace cilium-system \
   --create-namespace \
   --set nodeinit.enabled=true \
   --set kubeProxyReplacement=partial \
   --set hostServices.enabled=false \
   --set externalIPs.enabled=true \
   --set nodePort.enabled=true \
   --set hostPort.enabled=true \
   --set ipam.mode=kubernetes \
   --set hubble.enabled=true \
   --set hubble.listenAddress=":4244" \
   --set hubble.relay.enabled=true \
   --set hubble.ui.enabled=true \
   --set hubble.ui.ingress.enabled=true \
   --set "hubble.ui.ingress.hosts[0]=hubble.docker-setup.inmylab.de"