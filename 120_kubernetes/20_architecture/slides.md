## Architecture

![Control Plane und Worker Nodes](120_kubernetes/20_architecture/nodes.drawio.svg) <!-- .element: style="float: right; width: 25%;" -->

Cluster bestehen aus Knoten (Nodes)

Die Verwaltung des Cluster übernimmt die Control Plane

Die Control Plane besteht aus Master Nodes

Anwendungen werden nur auf bestimmten Knoten ausgeführt (Worker Nodes)

---

## Worker Nodes

![Dienste auf Worker Nodes](120_kubernetes/20_architecture/worker.drawio.svg) <!-- .element: style="float: right; width: 30%;" -->

Worker Nodes führen containerisierte Dienste aus

`kubelet` verwaltet Pod-Beschreibungen und steuert die Container Runtime

Die Container Runtime kümmert sich um die einzelnen Container

Die Netzwerkkommunikation von Services übernimmt `kube-proxy`

`kube-proxy` verwaltet Regeln, damit Services erreichbar sind

---

## Control plane

![Dienste der Control Plane](120_kubernetes/20_architecture/controller.drawio.svg) <!-- .element: style="float: right; width: 35%;" -->

Master Nodes bilden die Control Plane und verwalten den Cluster

Der `api-server` stellt die Kubernetes API bereit

Alle Daten des Clusters werden in `etcd` gespeichert

`etcd` ist ein Key-Value-Speicher

`kube-scheduler` weist Pods einem Worker zu

`kube-controller-manager` führt Controller aus, die den Clusterzustand an die Ressourcen anpassen