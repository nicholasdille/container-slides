# Avoiding Service Accounts

Make sure to prepare your environment according to `prepare.sh`.

Avoid service accounts using env vars

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: foo
spec:
  containers:
  - name: foo
    image: nginx
    env:
    - name: MY_NODE_NAME
      valueFrom:
        fieldRef:
          fieldPath: spec.nodeName
    - name: MY_POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: MY_POD_NAMESPACE
      valueFrom:
        fieldRef:
          fieldPath: metadata.namespace
EOF
kubectl exec -it foo -- printenv | grep MY_
```

Avoid service accounts using files

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: bar
  labels:
    app: demo
    components: frontend
    version: "1"
spec:
  containers:
  - name: bar
    image: nginx
    volumeMounts:
    - name: podinfo
      mountPath: /etc/podinfo
  volumes:
  - name: podinfo
    downwardAPI:
      items:
      - path: "labels"
        fieldRef:
          fieldPath: metadata.labels
EOF
kubectl exec -it bar -- cat /etc/podinfo/labels
```
