## Storage

![Volumes](120_kubernetes/12_volumes/volumes.drawio.svg) <!-- .element: style="float: right; width: 8em;" -->

Most applications require data

Be it static content, e.g. for web servers

Or directories for maintaining dynamic data, e.g. data directory for a database

### Volumes

Volumes provide storage for pods

Temporary storage using `emptyDir`

Host local storage using `hostPath`

Volumes can also be hosted by storage backends, e.g. NFS
