# Service Account with Image Pull Secrets

Make sure to prepare your environment according to `prepare.sh`.

Image pull secrets in service accounts

```sh
kubectl create secret docker-registry registry.company.com \
    --docker-server=registry.company.com \
    --docker-username=ssrv_reg_user \
    --docker-password="Secr3t!"
```

Add image pull secret to service account

```sh
kubectl patch serviceaccount default \
    --patch '{"imagePullSecrets": [{"name": "registry.company.com"}]}'
```

Display service account

```sh
kubectl get serviceaccount default -o yaml
```

Run container with default service account

```sh
kubectl run nginx --image=nginx --restart=Never
```

Check pod for image pull secrets

```sh
kubectl get pod nginx -o yaml
```
