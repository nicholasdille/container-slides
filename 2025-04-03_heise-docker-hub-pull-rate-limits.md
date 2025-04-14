# Docker Hub Rate Limits

[See canonical location](https://www.heise.de/hintergrund/Container-Images-laden-Docker-Hub-Rate-Limits-im-Griff-behalten-10338706.html)

Docker hatte kürzlich angekündigt, die Rate Limits für das Herunterladen (Pull) von Container Images von Docker Hub zu verschärfen. Diese Änderung sollte zum 01.04.2025 aktiv werden und Docker dabei unterstützen, den Betrieb von Docker Hub rentabel zu gestalten. Es ist nachvollziehbar, dass Docker kostendeckend arbeiten muss. Andererseits haben Ankündigungen dieser Art weltweite Auswirkungen. Durch die weite Verbreitung von Docker Hub, sind unzählige Entwickler auf der ganzen Welt von den Pull Rate Limits in Docker Hub betroffen. Umso besser ist es, dass die [Verschärfung der Rate Limits im letzten Moment zurückgenommen](XXX) wurde. Trotzdem bietet es sich an, die verfügbaren Optionen zu prüfen, um auf zukünftige Veränderungen an dem Rate Limit vorbereitet zu sein.

Es gibt allerdings einige Optionen, um diese Beschränkungen zu umgehen. Der Use Case und die Umgebung bestimmen, wie aufwendig eine mögliche Lösung ausfällt. Grundsätzlich müssen folgende Situationen betrachtet werden, um die passende Lösung auszusuchen: Abhängig von der Arbeitsweise und den Aufgaben können Entwickler auf ihrem Arbeitsgerät von den Pull Rate Limits betroffen sein. Wenn Build-Prozesse lokal gestartet werden, addieren sich die Container Image Pulls schnell auf, so dass die Arbeit durch die Pull Rate Limits gestört wird. Sobald Änderungen durch zentrale CI/CD-Pipelines überprüft werden, fallen in der zentralen Infrastruktur Container Image Pulls an, die durch das Erreichen der Limits zu nervigen Abbrüchen führen. Aber auch zentrale Infrastruktur wie Kubernetes-Cluster aber auch einzelne Docker-Hosts greifen auf Docker Hub zu und können von den Pull Limits betroffen sein.

Die Auswirkungen können zur Folge haben, dass Entwickler ausgebremst werden und dass zentrale Dienste nicht ausgerollt und aktualisiert werden können. Besonders schmerzhaft sind die Auswirkungen, wenn kein Budget vorhanden ist - wie es bei Open Source-Projekten der Fall ist.

## Entwickler

In der Regel verwenden Entwickler kein Docker-Konto und laden Container Images daher anonym herunter. Daher wird das Rate Limit auf der Basis der IPv4-Adresse berechnet. In Unternehmen ist das Rate Limit schnell erreicht, weil der Internetzugang von viele Entwicklern gleichzeitig verwendet wird und daher eine einzelne IPv4-Adresse als Quelle zum Einsatz kommt.

Als Privatperson ist der einfachste Weg ein kostenloses Konto anzulegen. Dadurch erhöht sich die Anzahl von Container Image Pulls auf 100 pro Stunde und die Arbeit mit Container Images sollte ohne Unterbrechungen möglich sein.

Unternehmen jeder Größe können durch [kostenpflichtige Pläne](https://www.docker.com/pricing/) die Pull Limits aufheben. Allerdings verursacht die Pflege von Docker-Konten pro Mitarbeiter Aufwand im Lizenzmanagement, in der IT und auch beim Entwickler. Jeder betroffene Mitarbeiter muss ein persönliches Konto anlegen, das anschließend einem Team- oder Business-Plan hinzugefügt werden muss. Lediglich im Business-Plan kann diese Pflege durch den Einsatz von Single Sign-On vermieden werden.

Durch den Einsatz von Docker Desktop könnten bereits die notwendigen Pläne vorhanden sein. Da Docker Desktop keine Lizenzkontrolle durchführt, ist der Einsatz des Docker-Kontos beim Entwickler nicht zwingend erforderlich. Daher ist es gegebenenfalls notwendig, die Konten am Arbeitsplatz des Entwicklers einzurichten.

## CI/CD-Jobs und zentrale Infrastruktur

Sind CI/CD-Jobs oder zentrale Infrastruktur wie Kubernetes-Cluster von den Pull Limits für Container Image betroffen, stehen die folgenden Optionen zur Verfügung, um Abhilfe zu schaffen. In beiden Fällen sind Anpassungen an der Infrastruktur notwendig.

Grundsätzlich erfordern Änderungen an der zentralen Infrastruktur Zeit und Kommunikation. Änderungen müssen geplant, getestet und geordnet ausgerollt werden. Gleichzeitig ist die Kommunikation zu den betroffenen Benutzergruppen unerlässlich, damit die neuen Möglichkeiten bekannt sind und notwendige Anpassungen rechtzeitig durchgeführt werden können.

Option 1: Nutzung öffentlicher Spiegel von Docker Hub

Es gibt einige wenige Anbieter, die einen öffentlichen Spiegel von Docker Hub betreiben und kostenlos zu Verfügung stellen, z.B. [Amazon Elastic Container Registry (ECR) Public](https://docs.aws.amazon.com/AmazonECR/latest/public/what-is-ecr.html) inklusive [Suche](https://gallery.ecr.aws/) oder [Google Container Registry (GCR)](https://cloud.google.com/artifact-registry/docs/pull-cached-dockerhub-images).

Obwohl es nach einer einfachen Abhilfe klingt, ist das Risiko hoch, dass zu einem späteren Zeitpunkt ebenfalls Rate Limits eingeführt werden oder die Fair Use-Richtlinien überschritten werden.

Option 2: Spiegeln einzelner Images

Wenn bereits eine private Container Registry im Unternehmen betrieben wird, können die benötigten, offiziellen Container Images darin gespiegelt werden. In diesem Fall ist besondere Sorgfalt notwendig, um neue Image Tags sowie die Aktualisierungen bestehender Image Tags zu erkennen und Kopien in der privaten Container Registry anzulegen. Ein hilfreiches Werkzeug dafür ist [`regctl image copy`](https://github.com/regclient/regclient/blob/main/docs/regctl.md#image-commands), das den umständiglichen Download und Upload mit `docker save` und `docker load` vermeidet.

Der Nachteil an diesem Vorgehen ist die Tatsache, dass die gespiegelten Container Images regelmäßig auf Aktualisierungen geprüft werden müssen. Dafür muss die Liste der gespiegelten Container Images gepflegt werden. Neue Anforderungen der Entwickler benötigen einen manuellen Eingriff. Außderdem werden regelmäßig Anfragen an Docker Hub gesendet, um die Aktualität zu prüfen. Diese Anfragen zählen zwar nicht in die Rate Limits, können aber vermieden werden. Die folgende Lösung ist dem spiegeln von Container Image deutlich überlegen.

Option 3: Privater Pull Through-Proxy

Die komfortabelste Lösung stellt der Pull Through-Proxy dar. Dieser wird als sogenannter [*Registry Mirror* im Docker Daemon](https://docs.docker.com/docker-hub/image-library/mirror/) konfiguriert und wird bei jedem Zugriff anstelle von Docker Hub kontaktiert. Dadurch erfolgt die Nutzung für den Entwickler völlig transparent. Jedes heruntergeladene Container Image wird zwischengespeichert und kann an viele Benutzer im Unternehmen ausgeliefert werden, ohne dass jedes Mal ein Download von Docker Hub erfolgen muss. Der Proxy sollte ein [Access Token eines kostenpflichtigen Kontos](https://docs.docker.com/security/for-admins/access-tokens/) verwenden, um die Pull Rate Limits aufzuheben.

Der Pull Through-Proxy kann sowohl für CI/CD-Jobs und zentrale Infrastruktur als auch auf den Arbeitsgeräten der Entwickler zum Einsatz kommen.

Einige Beispiele für Pull-Through-Proxy sind der [GitLab Dependency Proxy](https://docs.gitlab.com/user/packages/dependency_proxy/) oder [Jfrog Remote Docker Repositories](https://jfrog.com/help/r/jfrog-artifactory-documentation/remote-docker-repositories). Abhängig von der eingesetzten Lösung lässt sich das Verhalten anpassen, z.B. kann die Vorhaltezeit angepasst werden oder wie lange nach einer Aktualisierung darauf verzichtet wird erneut mit Docker Hub Kontakt aufzunehmen.

## Open Source-Projekte

Die Image Pull Rate Limits stellen eine besondere Herausforderung für Open Source-Projekte dar. Oft steht kein Sponsor zur Verfügung, um für Hosting-Kosten aufzukommen. Es existieren zwar mehrere Alternativen zu Docker Hub, allerdings wird oft nur eine begrenzte Menge an Speicherplatz für Container Images angeboten. Daher bietet es sich an, eine Bewerbung an eines der Open Source-Programme zu senden, z.B. [Docker-sponsored Open Source Program](https://www.docker.com/community/open-source/application/) oder [GitLab for Open Source](https://about.gitlab.com/solutions/open-source/join/). In der Regel ist jedes Jahr eine Verlängerung der Unterstützung notwendig. Das macht die Zukunft etwas ungewiss.

## Zusammenfassung

Auch wenn die Verschärfung der [Rate Limits für Docker Hub ausgesetzt](XXX) wurde, sollte man sich mich der Fragestellung beschäftigen und eine passende Lösung auswählen. Besser die Umsetzung erfolgt ohne Zeitdruck und man ist vorbereitet.
