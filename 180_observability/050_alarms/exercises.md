# Alerts

!!! goal "Ziel"
    In diesem Projekt lernst du, wie man in Grafana Alerts einrichtet und testet. Du wirst:

    - einen Contact Point für Benachrichtigungen erstellen
    - eine Notification Policy konfigurieren
    - eine Alert Rule erstellen, die auf bestimmte Log-Ereignisse reagiert
    - den Alert auslösen und die Benachrichtigung testen

!!! tipp "Hilfsmittel"

    - Versuche, die Aufgaben eigenständig zu lösen. Bei jeder Aufgabe findest du einen ausklappbaren Block mit einem Lösungsvorschlag, falls du nicht weiterkommst.

## Aufgabe 1 - Alerting mit Grafana

### Aufgabe 1.1 - Contact Point einrichten

Erstelle einen neuen Contact Point in Grafana mit folgender Konfiguration:

- Name: `Admin E-Mail`
- Type: `Email`
- E-Mail-Adresse: `admin@example.com`

??? help "Lösung (Klicken Sie auf den Pfeil, falls Sie nicht weiterkommen)"

    - Wechsle in Grafana in den Bereich **Alerting**.
    - Klicke auf **Contact points**.
    - Klicke auf **Create contact point**.
    - Setze den Namen auf `Admin E-Mail`.
    - Wähle als Typ `Email`.
    - Gib als E-Mail-Adresse `admin@example.com` ein.
    - Klicke auf **Save contact point**.

### Aufgabe 1.2 - Notification Policy erstellen

Erstelle eine neue Notification Policy in Grafana mit folgender Konfiguration:

- Label: `team=admin`
- Contact Point: `Admin E-Mail`
- Group wait: `0s`
- Group interval: `1s`
- Repeat interval: `4h`

Die Zeiten sind hier so kurz gewählt, damit du die Alerts schnell testen kannst. In der Praxis sollten diese Zeiten natürlich an deine Bedürfnisse angepasst werden.

??? help "Lösung (Klicken Sie auf den Pfeil, falls Sie nicht weiterkommen)"

    - Wechsle in Grafana in den Bereich **Alerting**.
    - Klicke auf **Notification policies**.
    - Klicke auf **New child policy**.
    - Setze das Label auf `team=admin`.
    - Wähle als Contact Point `Admin E-Mail`.
    - Klicke auf `Override general timings`.
    - Setze Group wait auf `0s`.
    - Setze Group interval auf `1s`.
    - Setze Repeat interval auf `4h`.
    - Klicke auf **Save policy**.


### Aufgabe 1.3 - Alert Rule erstellen

Erstelle eine neue Alert Rule in Grafana mit folgender Konfiguration:

- Name: `Wrong login link accessed`
- Data source: `Loki`
- Query: `sum(count_over_time({app="traefik"} | json RequestPath | RequestPath="/loginn" [1m]))`
- Condition: `IS ABOVE 0`
- Folder: `Traefik`
- Die Notification Policy `team=admin` soll genutzt werden.
- Evaluation alle 10 Sekunden
- Pending period: `0s`
- Keep firing for: `0s`
- Alert state if no data or all values are null: `Normal`
- Aktiviere `Advanced options` bei "Configure notifications"


??? help "Lösung (Klicken Sie auf den Pfeil, falls Sie nicht weiterkommen)"

    - Wechsle in Grafana in den Bereich **Alerting**.
    - Klicke auf **Alert rules**.
    - Klicke auf **New alert rule**.
    - Setze den Namen auf `Wrong login link accessed`.
    - Wähle als Datenquelle `Loki`.
    - Setze die Abfrage auf `sum(count_over_time({app="traefik"} | json RequestPath |  RequestPath="/loginn" [1m]))`.
    - Setze die Bedingung auf `IS ABOVE 0`.
    - Klicke auf `New folder` und erstelle einen neuen Ordner mit dem Namen `Traefik`.
    - Klicke auf `Add labels` und füge das Label `team=admin` hinzu.
    - Klicke auf `New evaluation group` und erstelle eine neue Gruppe mit beliebigem Namen.
    - Setze die Evaluation auf `10s`.
    - Setze Pending period auf `0s`.
    - Setze Keep firing for auf `0s`.
    - Klicke auf `Configure no data and error handling`.
    - Setze Alert state if no data or all values are null auf `Normal`.
    - Unter 5. "Configure notifications" aktiviere `Advanced options`.
    - Klicke auf **Save**.

### Aufgabe 1.4 - Alert testen

- Rufe `https://mailpit.cluster.<VSCode-URL>` auf.

Hier können wir beobachten welche E-Mails versendet werden, wenn der Alert ausgelöst wird.

- Rufe deine Grafana Instanz unter `/loginn` auf.
- Beobachte, dass der Alert ausgelöst wird.
- Beobachte wie der Alert in Mailpit ankommt.
- Klicke in Mailpit auf den Alert und schaue dir die Details an.
- Klicke auf den Link in der E-Mail, um die Alert Rule in Grafana zu öffnen.
- Beobachte wie der Alert wieder auf `Normal` wechselt.
- Schaue dir ebenfalls die Mail dazu an.


<!--
## Aufgabe 2 - Alert manager

TODO: Hier was mit Alertmanager machen.
-->
