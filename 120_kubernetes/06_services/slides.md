## Services

Pods erhalten nur eine dedizierte IP-Adresse<br> aber keinen DNS-Namen

![Services verteilen Anfragen auf mehrere Pods](120_kubernetes/06_services/dns.drawio.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

### Services bieten DNS

DNS-Einträge für Pods

Services implementieren Service Discovery

### Services bieten Lastverteilung

![Services verteilen Anfragen auf mehrere Pods](120_kubernetes/06_services/load_balancing.drawio.svg) <!-- .element: style="float: right; padding-left: 1em;" -->

Services sind ein Reverse Proxy mit dedizierter IP

Sie verteilen Anfragen auf mehrere Pods
