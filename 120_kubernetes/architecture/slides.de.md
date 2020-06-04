## Organisatorisches

### Dieses Kapitel geht von folgenden Voraussetzungen aus:

Pods, Services, Labels sind bekannt

Praktische Aufgabe wurden bisher in "magisch erstelltem" Cluster ausprobiert

Vielleicht wurden die Cluster mit [`kind`](https://kind.sigs.k8s.io/) erstellt

### Für die Erstellung dieses Videos entstand folgender Aufwand:

Planung: 0,5 (fertig)

Folien erstellen und Demos testen: 2,0 (in Arbeit)

Aufnahme: - (offen)

---

## Komponenten

Cluster bestehen aus Knoten (Nodes)

Container werden nur auf bestimmten Knoten ausgeführt (Worker Nodes)

Die Verwaltung des Cluster übernimmt die Control Plane

Die Control Plane besteht aus Master Nodes

![](120_kubernetes/architecture/nodes.drawio.svg)

---

## Praxis: Knoten erkunden - Vorbereitung

Ausrollen eines Clusters mit `kind`

Der Cluster wird einen Master und einen Worker enthalten

Erstelle eine Datei `kind.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
```

Erstelle den Cluster:

```plaintext
kind create cluster --config kind.yaml
```

### Dieser Cluster wird im Laufe dieses Kapitels noch benötigt

---

## Praxis: Knoten erkunden

Knoten des Cluster auflisten:

```plaintext
$ kubectl get nodes
NAME                 STATUS   ROLES    AGE   VERSION
kind-control-plane   Ready    master   78s   v1.18.2
kind-worker          Ready    <none>   41s   v1.18.2
```

---

## Worker Nodes

Worker Nodes führen containerisierte Dienste aus

`kubelet` verwaltet PodSpecs und die daraus resultierenden Container

Die Netzwerkkommunikation von Services übernimmt `kube-proxy`

`kube-proxy` verwaltet Regeln, damit Services erreichbar sind

Die `container runtime` kümmert sich um die einzelnen Container

Docker ist eine `container runtime` (unter vielen)

![](120_kubernetes/architecture/worker.drawio.svg)

---

## Praxis: Worker Nodes

Die Prozessliste des Workers zeigt die Komponenten:

```plaintext
$ docker exec -it kind-worker ps fxwwo pid,cmd
  PID CMD
  123 /usr/local/bin/containerd
  430 /usr/bin/kubelet
  479 /usr/local/bin/containerd-shim-runc-v2
  528  \_ /pause
  598  \_ /bin/kindnetd
  504 /usr/local/bin/containerd-shim-runc-v2
  535  \_ /pause
  607  \_ /usr/local/bin/kube-proxy
```

### (gekürzt)

---

## Control plane

Master Nodes bilden die Control Plane und verwalten der Cluster

Der `api-server` stellt die Kubernetes API bereit

Alle Daten des Clusters werden in `etcd` gespeichert

`etcd` ist ein Key-Value-Speicher

`kube-scheduler` weist Pods einem Worker Node zu

`kube-controller-manager` führt Controller aus, die den Clusterzustand den Clusterressourcen anpassen

![](120_kubernetes/architecture/master.drawio.svg)

---

## Controller

Controller sind verantwortlich für einen oder mehrere Ressourcentypen

Eine Endlosschleife überprüft den aktuellen Zustand...

...und versucht den erwarteten Zustand zu erreichen

Mitgelieferte Ressourcentypen umfassen Pod, Service, Deployment u.v.m.

`kube-controller-manager` beinhaltet alle mitgelieferten Controller

### Beispiel

1. Eine Ressource vom Typ `Pod` wird erstellt
1. Die API erzeugt einen Event dazu
1. Der passende Controller reagiert darauf...
1. ...und erstellt einen Pod über die API

---

## Praxis: Control plane 1/

Die Prozessliste des Master zeigt die Komponenten:

```plaintext
$ docker exec -it kind-control-plane ps fxwwo pid,cmd
  PID CMD
  129 /usr/local/bin/containerd
  353 /usr/local/bin/containerd-shim-runc-v2
  472  \_ /pause
  660  \_ etcd
  357 /usr/local/bin/containerd-shim-runc-v2
  474  \_ /pause
  564  \_ kube-scheduler
  363 /usr/local/bin/containerd-shim-runc-v2
  459  \_ /pause
  571  \_ kube-controller-manager
  389 /usr/local/bin/containerd-shim-runc-v2
  458  \_ /pause
  620  \_ kube-apiserver
```

### (gekürzt)

---

## Praxis: Control plane 2/2

Komponenten auf einen Blick mit Zuordnung zu Knoten:

```plaintext
$ kubectl get pods -A -o wide
NAME                                         NODE
etcd-kind-control-plane                      kind-control-plane
kindnet-22fnw                                kind-worker
kube-apiserver-kind-control-plane            kind-control-plane
kube-controller-manager-kind-control-plane   kind-control-plane
kube-proxy-687gr                             kind-worker
kube-scheduler-kind-control-plane            kind-control-plane
```

### (gekürzt)

`kubelet` ist ein regularär Prozess und daher nicht zu sehen

---

## Kommunikation

### Von den Nodes zur Control Plane

Alle Dienste des Workers sprechen direkt mit dem `api-server`

### Von der Control Plane zu Nodes

`kubelet` nimmt alle Kommunikation entgegen

![](120_kubernetes/architecture/communication.drawio.svg)

---

## Skalierung

Cluster können in unterschiedlichen Skalierungen existieren

| Typ            | Master | Worker |
|----------------|:------:|:------:|
| Ein Knoten     | 0,5    | 0,5    |
| Mehrere Worker | 1      | 1+     |
| Hochverfügbar  | 3      | 1+     |

`etcd` kann als Container im Cluster laufen

`etcd` kann als externer Dienst konsumiert werden

---

## Zusammenfassung

Cluster bestehen aus Master Nodes und Worker Nodes

Worker Nodes führen containerisierte Dienste aus

Master Nodes bilden die Control Plane

Die Control Plane verwaltet den Cluster

### Nächstes Kapitel

Knoten untersuchen
