## Pod Service Accounts

Pods can access the Kubernetes API

Special service called `kubernetes` present in `default` namespace

Pods get environment variables to find API endpoint

Pods automatically mounts service account token

By default, service account `default` is used

Service account `default` does not have any (Cluster)Role

---

## Prevent token mounting 1/

No need to Kubernetes API? Disable token mounting in `Pod`:

```yaml [2,7]
apiVersion: v1
kind: Pod
metadata:
  name: foo
spec:
  serviceAccountName: foo
  automountServiceAccountToken: false
#...
```

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Prevent token mounting 2/2

Don't want the service account to be mounted?

Disable token mounting in `ServiceAccount`:

```yaml [2,5]
apiVersion: v1
kind: ServiceAccount
metadata:
  name: foo
automountServiceAccountToken: false
#...
```

Can be overridden by specifying `automountServiceAccountToken: true` in the pod spec

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Accessing the Kubernetes API<br/>from pods

Some services require specific permissions

Use RBAC to provide only required permissions

Access Kubernetes API using environment variables:

```bash
$ printenv | grep KUBERNETES_ | sort
#...
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
KUBERNETES_SERVICE_PORT_HTTPS=443
```

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Service accounts without token

Service accounts are created without corresponding `Secret` [](https://kubernetes.io/docs/concepts/configuration/secret/#service-account-token-secrets)

Introduced in Kubernetes 1.24

Automounted service accounts always get a temporary token

Create special secret to obtain long-lived token:

```bash [2,7-9]
kubectl create sa foo
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: foo-token
  annotations:
    kubernetes.io/service-account.name: foo
type: kubernetes.io/service-account-token
EOF
```

### DEMO [<i class="fa fa-comment-code"></i>](https://github.com/nicholasdille/container-slides/blob/master/120_kubernetes/rbac/service_account.demo "service_account.demo")

---

## Deleting a service account

Access to Kubernetes API stops working immediately

Credentials remain accessible by pod

### Recovery is not easy

Not enough to create a new service account with the same name

Issued token does not work for new service account

Restart of pod is required

---

## Short-lived tokens

Short-lived JWTs [](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-an-api-token-for-a-serviceaccount)

XXX kubectl create token

XXX --duration

XXX bind to lifetime of another resource: --bound-object-kind, --bound-object-name

---

## Add Image Pull Secrets to a Service Account

XXX https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#add-imagepullsecrets-to-a-service-account

1. Create secret with image pull secrets
1. Create service account
1. Add image pull secrets to service account
1. Use service account in pod

---

## Service Account Token Volume Projection

XXX https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#serviceaccount-token-volume-projection

XXX https://kubernetes.io/docs/concepts/storage/projected-volumes/#serviceaccounttoken

---

## Downward API to avoid Service Accounts

XXX https://kubernetes.io/docs/tasks/inject-data-application/downward-api-volume-expose-pod-information/

XXX pod fields

XXX container fields

--

## New

Secret types [](https://kubernetes.io/docs/concepts/configuration/secret/#secret-types)

Immutable secrets [](https://kubernetes.io/docs/concepts/configuration/secret/#secret-immutable)

What is `kubernetes.io/enforce-mountable-secrets`? [](https://kubernetes.io/docs/concepts/security/service-accounts/#enforce-mountable-secrets)