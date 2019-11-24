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

# Prepare shell
source <(kubectl completion bash)
alias k=kubectl
complete -F __start_kubectl k
source <(helm completion bash)

# Deploy cluster
k3d create --name o11y --image docker.io/rancher/k3s:v1.0.0 --api-port 443 --publish 80:80
export KUBECONFIG=$(k3d get-kubeconfig --name o11y)

curl -sLf https://get.helm.sh/helm-v2.16.1-linux-amd64.tar.gz | tar -xvz -C /usr/local/bin --strip-components=1 linux-amd64/helm linux-amd64/tiller
helm init --client-only
helm plugin install https://github.com/rimusz/helm-tiller

# Log shipping
helm tiller run helm repo add loki https://grafana.github.io/loki/charts
helm tiller run helm install loki/loki --name loki --namespace default --values loki-values.yaml
helm tiller run helm install loki/promtail --name promtail --namespace default --values promtail-values.yaml

# Metrics collection
helm tiller run helm install stable/influxdb --name influxdb --namespace default --values influxdb-values.yaml
kubectl apply -f telegraf-rbac.yaml
kubectl create secret generic monitoring --from-literal=monitor_host=http://influxdb:8086 --from-literal=monitor_database=demo --from-literal=monitor_username=admin --from-literal=monitor_password=influxdbadmin
kubectl apply -f telegraf.yaml

# Visualization
helm tiller run helm install stable/grafana --name grafana --namespace default --values grafana-values.yaml

# Administration
kubectl create secret generic chronograf --from-file <(htpasswd -nbB admin chronografadmin)
helm fetch stable/chronograf --untar
patch -p0 -i chronograf.patch
helm template chronograf --values chronograf-values.yaml | sed 's/release-name-//g' | kubectl apply -f -

# Analysis
#helm tiller run helm install stable/kapacitor --name kapacitor --namespace default --values kapacitor-values.yaml
helm fetch stable/kapacitor --untar
patch -p0 -i kapacitor.patch
helm template kapacitor --values kapacitor-values.yaml | sed 's/release-name-//g' | kubectl apply -f -

# Upgrade
#helm tiller helm upgrade telegraf stable/telegraf --values telegraf-values.yaml
```
