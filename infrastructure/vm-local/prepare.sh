#!/bin/bash
set -o errexit

uniget install containerd kubeadm kubectl helm cilium
systemctl daemon-reload
systemctl enable containerd
systemctl start containerd

kubeadm init \
    --apiserver-advertise-address=127.0.0.1 \
    --apiserver-bind-port=6443 \
    --pod-network-cidr=10.244.0.0/16 \
    --service-cidr=10.96.0.0/12

helm repo add cilium https://helm.cilium.io/
helm upgrade --install --namespace kube-system --create-namespace \
    cilium cilium/cilium \
        --set kubeConfigPath=/etc/kubernetes/admin.conf
        --set encryption.nodeEncryption="false" \
        --set envoy.enabled="false" \
        --set ipam=kubernetes \
        --set kubeProxyReplacement="true" \
        --set operator.replicas=1 \
        --set serviceAccounts.cilium.name=cilium \
        --set serviceAccounts.operator.name=cilium-operator \
        --set tunnel-protocol=vxlan \
        --set prometheus.enabled="true" \
        --set operator.prometheus.enabled="true" \
        --set hubble.enabled="true" \
        --set hubble.relay.enabled="true" \
        --set hubble.ui.enabled="true" \
        --set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}" \
        --set hubble.metrics.enableOpenMetrics="true" \
        --set hostFirewall.enabled="false" \
        --set podSecurityContext.appArmorProfile.type="Unconfined"

        #--set prometheus.serviceMonitor.enabled="true" \
        #--set operator.prometheus.serviceMonitor.enabled="true" \
        #--set hubble.metrics.serviceMonitor.enabled="true" \
        #--set hubble.relay.prometheus.serviceMonitor.enabled="true" \

# https://github.com/hetznercloud/hcloud-cloud-controller-manager
