## Blog bereitstellen

![WordPress mit MySQL](120_kubernetes/13_wordpress/example.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

Uns stehen alle Werkzeuge für einen Beispieldienst zur Verfügung

Wir werden WordPress mit MySQL ausrollen

Deployment für WordPress und MySQL

Services für Zugriff auf Frontend und Backend

Gemeinsames Secret für Datenbankkennwort

Datenbank auf Host persistieren

### Nachteile der gewählten Dienste

<i class="fas fa-minus" style="width: 1em;"></i> WordPress kann nicht einfach skaliert werden (Datenkonsistenz)

<i class="fas fa-minus" style="width: 1em;"></i> MySQL kann nicht einfach skaliert werden (Datenkonsistenz)
