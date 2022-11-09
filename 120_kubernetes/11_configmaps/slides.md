## Configuration data

![ConfigMaps](120_kubernetes/11_configmaps/configmaps.drawio.svg) <!-- .element: style="float: right; width: 25%;" -->

Containers require configuration data

Configuration files are often generated on the fly...

...and added during container start

### ConfigMaps

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: foo
data:
  file1.ext: |
    data1
  file2.ext: |
    data2
```
<!-- .element: style="float: right; width: 35%;" -->

ConfigsMaps store one or more values...

...which can be literals as well as files

Multi-line values are possible

Values can be provided to pods as environment variables
