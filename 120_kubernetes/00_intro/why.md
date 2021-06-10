## Betrieb von Containern

Auf einem Host sind Container einfach zu verwalten

Produktion benötigt Ausfallsicherheit

Dafür ist mehr als ein Host notwendig

### Container-Orchestrierer

Er übernimmt die Verwaltung von Containern auf mehreren Hosts

### Angebote

Kubernetes

Docker Swarm

---

## Aufgaben des Orchestrierers

<div style="display: grid; grid-template-columns: 1fr 1fr; grid-gap: 1em; text-align: left; font-size: larger;">

<div>

### Rollout

Verteilen von Containern auf mehrere Hosts

Ausbalancieren der Ressourcennutzung

### Skalierung

Verwaltung von Kopien eines Containers

Hinzufügen und Entfernen von Kopien

</div>
<div>

### Aktualisierung

Austausch von Containers mit einer neuen Version

Sicherstellen der Verfügbarkeit

### Wiederherstellung

Neustart fehlerhalfter Container

Kompensieren von Ausfällen

### Aufräumen

Löschen von Containern...

...inklusive aller Kopien

</div>

</div>

---

## Darum Container-Orchestrierer

Container-Orchestrierer nehmen Arbeit ab

Nutzung mehrerer Hosts

Sie können Ausfälle und Fehlverhalten kompensieren

Ops: Mehr Zeit für wichtigere Aufgaben

Kubernetes ist der Container-Orchestrierer mit der weitesten Verbreitung
