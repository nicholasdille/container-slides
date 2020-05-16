## Secrets

### Push deployment

Permissions in target environment required

Secrets are injected by pipeline

### Pull deployment

Deployments performed from inside the target environment

Secrets using [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets) or pulled from Vault

--

## Privileges

### Least privileges

Deny by default and add permissions

Use deploy keys but harder for auditing

Do not compromise

### Separation of concerns

Dedicated account per use case

Evaluate permissions per account

--

## Security in dev and ops

Make human interaction more secure

### Local development

Always add `.env` to your `.gitignore`

Place required environment variables in `.env`

### Troubleshooting

Default to read access to live environment

Limit interactive access to target system
