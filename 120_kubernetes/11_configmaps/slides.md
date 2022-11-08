## Configuration data

![ConfigMaps](120_kubernetes/11_configmaps/configmaps.drawio.svg) <!-- .element: style="float: right; width: 25%;" -->

Containers require configuration data

Configuration files are often generated on the fly...

...and added during container start

### ConfigMaps

ConfigsMaps store one or more values...

...which can be literals as well as files

Multi-line values are possible

Values can be provided to pods as environment variables
