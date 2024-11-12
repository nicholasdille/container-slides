# Service Accounts

Make sure to prepare your environment according to `prepare.sh`.

Image pull secrets in service accounts

```shell
kubectl create secret docker-registry registry.company.com --docker-server=registry.company.com --docker-username=ssrv_reg_user --docker-password="Secr3t!"
```

Add image pull secret to service account

```shell
kubectl patch serviceaccount default --patch '{"imagePullSecrets": [{"name": "registry.company.com"}]}'
```

Display service account

```shell
kubectl get serviceaccount default -o yaml
```

Run container with default service account

```shell
kubectl run nginx --image=nginx --restart=Never
```

Check pod for image pull secrets

```shell
kubectl get pod nginx -o yaml
```
