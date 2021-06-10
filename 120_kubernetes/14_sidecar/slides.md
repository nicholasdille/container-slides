## Mehrere Container im Pod?

![Pods vs. Containers](120_kubernetes/14_sidecar/containers.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

Müssen die Container als eine Einheit ausgerollt werden?

Können die Container nur gemeinsam skaliert werden?

Besteht eine 1:1-Beziehung zwischen den Containern?

### Hinweis

Frontend und Backend gehören in separate Pods

---

## Sidecars

![Pods vs. Containers](120_kubernetes/14_sidecar/containers.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

In der Regel gibt es einen Hauptcontainer

Alle anderen Container heißen Sidecars

Sidecars unterstützen den Hauptcontainer

Sidecars erfüllen Infrastrukturaufgaben

### Beispiele

Ein Sidecar überwacht den Hauptcontainer

Ein Sidecar sammelt Logs zur zentralen Auswertung
