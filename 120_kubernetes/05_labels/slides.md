## Labels

![Jede Ressource kann Labels enthalten](120_kubernetes/05_labels/labels.drawio.svg) <!-- .element: style="float: right;" -->

Labels sind das zweite zentrale Konzept

Jede Resource kann Labels haben, z.B. Pods

Labels werden zur Selektion verwendet

Labels werden eine wichtige Rolle in den nachfolgenden Lektionen spielen

Änderungen an Labels verursachen keinen Neustart

---

## Annotationen

Annotationen speichern Informationen

Annotationen haben keine Auswirkung auf das Verhalten von Kubernetes

Änderungen an Annotationen verursachen keinen Neustart

---

## Formelles über Labels und Annotationen

Format: `[<Präfix>/]<Name>: <Wert>`

### &lt;Präfix&gt;

Das optionale Präfix muss eine DNS-Subdomäne sein

### &lt;Name&gt;

Name darf maximal 63 Zeichen lang sein

### &lt;Wert&gt;

Werte von Labels müssen entsprechen: `^[a-z0-9_\-]+$`

Werte von Annotationen dürfen beliebigen Inhalt haben
