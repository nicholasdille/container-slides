## Pods aktualisieren

![Erstellen, Skalieren, Aktualisieren, Wiederherstellen, Löschen](120_kubernetes/08_update/lifecycle.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

ReplicaSets sind nur für das Skalieren zuständig

Containerisierte Dienste benötigen Lifecycle Management

Anwendungen mit vielen Pods sollen unterbrechungsfrei aktualisiert werden

### Deployments

Sie sind verantwortlich für das Aktualisieren und Wiederherstellen

---

## Deployment-Interna

![Deployment mit ReplicaSet und Pods](120_kubernetes/08_update/replicaset.drawio.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

### Verstecktes ReplicaSet

Deployments erstellen ein ReplicaSet

Das ReplicaSet übernimmt die Skalierung

Das ReplicaSet erhält ein zufälliges Suffix

Pods erhalten dadurch zwei Suffixe

![Deployment mit neuem und altem ReplicaSet](120_kubernetes/08_update/updates.drawio.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

### Updates

Updates verursachen ein neues ReplicaSet

Das Update wird durch Hoch- und Runterskalieren umgesetzt
