## Organisatorisches

### Dieses Kapitel geht von folgenden Voraussetzungen aus:

Pods sind bereits bekannt

Praktische Aufgabe wurden in "magisch erstelltem" Cluster ausprobiert

Vielleicht wurden die Cluster mit [`kind`](https://kind.sigs.k8s.io/) erstellt

### Für die Erstellung dieses Videos entstand folgender Aufwand:

Planung: 0,5 (fertig)

Folien erstellen und Demos testen: 1,0 (in Arbeit)

Aufnahme: - (offen)

---

## Komponenten

XXX langsam an Details gewinnendes Bild

XXX Control plane, master nodes, worker nodes

XXX https://kubernetes.io/docs/concepts/overview/components/

![](120_kubernetes/architecture/nodes.drawio.svg)

---

## Praxis: Komponenten

XXX Cluster mit `kind` ausrollen (je einmal Master und Worker)

Erstelle eine Datei `kind.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
```

Erstelle den Cluster:

```bash
kind create cluster --config kind.yaml
```

---

## Worker Nodes

XXX worker nodes

XXX kubelet

XXX kube-proxy

XXX container-runtime

XXX https://kubernetes.io/docs/concepts/overview/components/

XXX Praxis: Prozessliste anschauen

![](120_kubernetes/architecture/worker.drawio.svg)

---

## Control plane

XXX master nodes

XXX kube-api-server

XXX etcd

XXX kube-scheduler

XXX kube-controller manager

XXX https://kubernetes.io/docs/concepts/overview/components/

![](120_kubernetes/architecture/master.drawio.svg)

---

## Kommunikation: Von den Nodes zur Control Plane

XXX alle Dienste des Workers sprechen mit dem `api-server`

![](120_kubernetes/architecture/node-to-master.drawio.svg)

---

## Kommunikation: Von der Control Plane zu Nodes

XXX kubelet nimmt alle Kommunikation entgegen

XXX Beispiele

![](120_kubernetes/architecture/master-to-node.drawio.svg)

---

## Controller

XXX https://kubernetes.io/docs/concepts/architecture/controller/

---

## Skalierung

XXX

| Typ            | Master | Worker |
|----------------|:------:|:------:|
| Ein Knoten     | 0,5    | 0,5    |
| Mehrere Worker | 1      | 1+     |
| Hochverfügbar  | 3      | 1+     |

XXX etcd on master nodes (co-located)

XXX external etcd cluster

---

## Nächstes Kapitel

???
