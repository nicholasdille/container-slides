# Publish OpenID configuration

XXX https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#serviceaccount-token-volume-projection

XXX set `service-account-issuer` on `kube-apiserver` (see `kind.yaml`)

XXX is the following really necessary? see https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#service-account-issuer-discovery. Solve with `Ingress`?

XXX provide `.well-known/openid-configuration` endpoint:

```json
{
    "issuer": "https://$ISSUER_HOSTPATH/",
    "jwks_uri": "https://$ISSUER_HOSTPATH/keys.json",
    "authorization_endpoint": "urn:kubernetes:programmatic_authorization",
    "response_types_supported": [
        "id_token"
    ],
    "subject_types_supported": [
        "public"
    ],
    "id_token_signing_alg_values_supported": [
        "RS256"
    ],
    "claims_supported": [
        "sub",
        "iss"
    ]
}
```

XXX see builtin endpoint using `kubectl get --raw /.well-known/openid-configuration | jq`. It violates the OIDC Discovery Spec https://openid.net/specs/openid-connect-discovery-1_0.html because it is missing `authorization_endpoint`:

```json
{
  "issuer": "https://luigi.oidc.k8s.haufedev.systems",
  "jwks_uri": "https://10.11.8.209:6443/openid/v1/jwks",
  "response_types_supported": [
    "id_token"
  ],
  "subject_types_supported": [
    "public"
  ],
  "id_token_signing_alg_values_supported": [
    "RS256"
  ]
}
```

XXX provide `/keys.json` endpoint with contents of `kubectl get --raw /openid/v1/jwks`

Launch service to publish OpenID configuration:

```shell
kubectl get --raw /openid/v1/jwks >keys.json
cat <<EOF >openid-configuration.json
{
    "issuer": "https://my-cluster.dille.io/",
    "jwks_uri": "https://my-cluster.dille.io/keys.json",
    "authorization_endpoint": "urn:kubernetes:programmatic_authorization",
    "response_types_supported": [
        "id_token"
    ],
    "subject_types_supported": [
        "public"
    ],
    "id_token_signing_alg_values_supported": [
        "RS256"
    ],
    "claims_supported": [
        "sub",
        "iss"
    ]
}
EOF
kubectl create configmap foo \
    --from-file=keys.json \
    --from-file=openid-configuration=openid-configuration.json \
    --dry-run=client \
    --output=yaml \
| kubectl apply -f -
kubectl apply -f well-known-openid-configuration.yaml
```

XXX TODO: Ingress(Route)

Set audience on service account token:

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: alpine
spec:
  containers:
  - name: foo
    image: nginx:alpine
    volumeMounts:
    - mountPath: /var/run/secrets/tokens
      name: oidc-token
  volumes:
  - name: oidc-token
    projected:
      sources:
      - serviceAccountToken:
          path: oidc-token
          audience: foobar
```

XXX use `vault` with this https://developer.hashicorp.com/vault/docs/auth/jwt/oidc-providers/kubernetes