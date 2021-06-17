## Credentials

Secrets in environment variables are dangerous

Hard coding secrets in pod specifications is even more dangerous

### Secrets

Secrets are meant to store confidential information

![Secrets](120_kubernetes/10_secrets/secrets.drawio.svg) <!-- .element: style="width: 8em;" -->

Secrets can store literals as well as files

Secrets are only Base64 encoded but not encrypted

Secrets are not secret

### Alternatives

Bitnami Sealed Secrets

Vault Operator
