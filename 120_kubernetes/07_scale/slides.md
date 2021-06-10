## Skalieren

### Mehr Pods

![Pod2](images/kubernetes-icons/resources/unlabeled/pod.svg) <!-- .element: style="float: right; padding-left: 1em; padding-right: 1.4em;" -->

![Pod1](images/kubernetes-icons/resources/unlabeled/pod.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

Mehrere Pods können die Last abfangen

Identische Konfiguration aller Pods notwendig

### ReplicaSets

![ReplicaSet with two Pods](120_kubernetes/07_scale/replicaset.drawio.svg) <!-- .element: style="float: right;" -->

Konfigurierte Anzahl von Pods sicherstellen

Alle Pods werden aus einer Spezifikation erstellt

Die Pods sind identische Kopien

Labels dienen der Zuordnung von Pods

Pod-Namen enthalten ein zufälliges Suffix
