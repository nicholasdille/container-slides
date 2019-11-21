# Observability (o11y)

```bash
# Install Docker
curl -fL https://get.docker.com | sh

# Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

# Install k3d
curl -s https://raw.githubusercontent.com/rancher/k3d/master/install.sh | bash

# Prepare kubectl
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k

# Deploy cluster
k3d create --name o11y --publish 80:80
export KUBECONFIG=$(k3d get-kubeconfig --name o11y)

curl -sLf https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz | tar -xvz -C /usr/local/bin --strip-components=1 linux-amd64/helm linux-amd64/tiller
helm init --client-only
helm plugin install https://github.com/rimusz/helm-tiller

# https://github.com/helm/charts/tree/master/stable/influxdb
helm tiller run helm install stable/influxdb --name influxdb --namespace default --values influxdb-values.yaml

# https://github.com/helm/charts/tree/master/stable/grafana
helm tiller run helm install stable/grafana --name grafana --namespace default --values grafana-values.yaml

# https://github.com/helm/charts/tree/master/stable/telegraf
helm tiller run helm install stable/telegraf --name telegraf --namespace default --values telegraf-values.yaml

# https://github.com/helm/charts/tree/master/stable/chronograf
helm tiller run helm install stable/chronograf --name chronograf --namespace default --values chronograf-values.yaml

# https://github.com/helm/charts/tree/master/stable/kapacitor
helm tiller run helm install stable/kapacitor --name kapacitor --namespace default --values kapacitor-values.yaml

# https://github.com/grafana/loki/tree/master/production/helm
helm tiller run helm repo add loki https://grafana.github.io/loki/charts
helm tiller run helm install loki/loki --name loki --namespace default --values loki-values.yaml
helm tiller run helm install loki/promtail --name promtail --namespace default --values promtail-values.yaml

# Upgrade
#helm tiller helm upgrade telegraf stable/telegraf --values telegraf-values.yaml
```
