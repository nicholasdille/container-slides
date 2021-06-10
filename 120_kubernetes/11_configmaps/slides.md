## Konfigurationsdateien verwalten

![ConfigMaps](120_kubernetes/11_configmaps/configmaps.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

Container benötigen oft Konfigurationsdateien

Konfigurationsdateien stehen beim Bauen des Image noch nicht zur Verfügung

Diese werden oft in einem weiteren Build-Schritt hinzugefügt

### ConfigMaps

ConfigMaps nehmen einen oder mehr Werte auf

Die Werte können auch mehrere Zeilen umfassen

Werte können als Umgebungsvariable an Pods bereitgestellt werden
