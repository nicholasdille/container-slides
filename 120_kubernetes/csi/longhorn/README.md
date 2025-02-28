# Longhorn on Kubernetes

XXX https://kubernetes.io/docs/concepts/storage/storage-classes/

XXX `kind` with three nodes

```shell
kind create cluster --config=kind.yaml
helm repo add longhorn https://charts.longhorn.io
helm --namespace=longhorn-system upgrade --install --create-namespace \
    longhorn longhorn/longhorn
kubectl --namespace=longhorn-system port-forward svc/longhorn-frontend 8080:80
```

XXX http://localhost:8080/

Create storage class:

```shell
kubectl apply -f - <<EOF
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  name: longhorn-custom
provisioner: driver.longhorn.io
allowVolumeExpansion: true
parameters:
  numberOfReplicas: "3"
  staleReplicaTimeout: "2880" # 48 hours in minutes
  fromBackup: ""
  fsType: "ext4"
reclaimPolicy: Retain
EOF
```

XXX reclaimPolicy!!!

Create `PersistentvolumeClaim` and check the new volume in the UI:

```shell
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: longhorn-volv-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: longhorn-custom
  resources:
    requests:
      storage: 2Gi
EOF
```

See how `volumeMode` and `volumeName` were populated:

```shell
kubectl get pvc longhorn-volv-pvc -o yaml
```

Attach a pod:

```shell
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: volume-test
  namespace: default
spec:
  containers:
  - name: volume-test
    image: nginx:stable-alpine
    imagePullPolicy: IfNotPresent
    volumeMounts:
    - name: volv
      mountPath: /data
    ports:
    - containerPort: 80
  volumes:
  - name: volv
    persistentVolumeClaim:
      claimName: longhorn-volv-pvc
EOF
```

## ReclaimPolicy=Retain

XXX know the volume name

Create the PV manually:

```shell
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pvc-a5ffd4b8-9c6b-44cf-aeb2-b3a4295372bd
spec:
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 2Gi
  csi:
    driver: driver.longhorn.io
    fsType: ext4
    volumeAttributes:
      fromBackup: ""
      fsType: ext4
      numberOfReplicas: "3"
      staleReplicaTimeout: "2880"
      storage.kubernetes.io/csiProvisionerIdentity: 1740664844184-8424-driver.longhorn.io
    volumeHandle: pvc-a5ffd4b8-9c6b-44cf-aeb2-b3a4295372bd
  persistentVolumeReclaimPolicy: Retain
  storageClassName: longhorn-custom
  volumeMode: Filesystem
EOF
```

Create the PVC including the volume name:

```shell
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: longhorn-volv-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: longhorn-custom
  resources:
    requests:
      storage: 2Gi
  volumeName: pvc-a5ffd4b8-9c6b-44cf-aeb2-b3a4295372bd
EOF
```
