# Impersonate

Use read-only user for daily work and impersonate admin only when needed.

## Preparation

Create test namespace:

```bash
kubectl create namespace test
```

Create required (Cluster)Role(Binding):

```bash
kubectl apply -f rbac.yaml
```

Create context for read-only user:

```bash
TOKEN="$( kubectl --namespace=test create token reader --duration=3600s )"
CURRENT_CONTEXT="$( kubectl config current-context )"
CLUSTER_NAME="$( kubectl config view --output=json | jq --raw-output '.contexts[] | select(.name == "kind-foo") | .context.cluster' )"
kubectl config set-credentials test-reader --token=${TOKEN}
kubectl config set-context kind-test --user=test-reader --cluster="${CLUSTER_NAME}" --namespace=test
```

Switch tio read-only context:

```bash
kubectl config use-context kind-test
```

## Demo

Show permissions in namespace test:

```sh {"terminalRows":"29"}
kubectl auth can-i --list -n test
```

Succeed to access resource in namespace test:

```sh
kubectl -n test get all
```

Fail to access namespace default

```sh {"terminalRows":"21"}
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

Revert `kubeconfig`:

```sh
kubectl config delete-context kind-test
```
