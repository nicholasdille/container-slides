# Impersonate

XXX

## Preparation

XXX:

```bash
kubectl create namespace test
```

XXX:

```bash
kubectl apply -f rbac.yaml
```

XXX:

```bash
TOKEN="$(
    kubectl --namespace=test get secrets reader --output=json \
    | jq --raw-output '.data.token' \
    | base64 -d
)"
kubectl config set-credentials test-reader --token=${TOKEN}
kubectl config set-context kind-test --user=test-reader --cluster=kind-kind
```

XXX:

```bash
kubectl config use-context kind-test
```

## Demo

Show permissions in namespace test:

```sh
kubectl auth can-i --list -n test
```

Succeed to access resource in namespace test:

```sh
kubectl -n test get all
```

Fail to access namespace default

```sh
kubectl -n default get all
```

Fail to run pod in namespace test

```sh
kubectl -n test run -it --image=alpine --command -- sh
```

Run pod in namespace test using impersonation

```sh
kubectl -n test run -it --image=alpine --command --as=test-admin -- sh
```

Fail to remove pod

```sh
kubectl -n test delete pod sh
```

Remove pod using impersonation

```sh
kubectl -n test delete pod sh --as=test-admin
```

## Cleanup

None
