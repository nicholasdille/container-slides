## Speicherplatz bereitstellen

![Volumes](120_kubernetes/12_volumes/volumes.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

Nur wenige Anwendungen kommen ohne Daten aus

Mal sind es statische Daten wie Bilder<br>(z.B. für Webserver)

Oft sind es auch Verzeichnisse für dynamische Daten<br>(z.B. für Datenbanken)

### Volumes

Volumes stellen zusätzlichen Speicherplatz am Pod bereit

`emptyDir` bildet flüchtigen Speicher für Cache-Verzeichnisse ab

`hostPath` persistiert Daten auf einem Host

Volumes können auch Backend-Storage bereitstellen, z.B. NFS u.v.m. [<i class="fas fa-external-link-alt"></i>](https://kubernetes.io/docs/concepts/storage/volumes/#types-of-volumes)
