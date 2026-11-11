# Create infrastructure

```shell
make debug
make init
make apply
make state ssh infrastructure.json
```

For testing, override individual variables:
- `REMOTE_STATE` - whether to use remote or local state (default: true)
- `SEAT_COUNT` - number of seats to create (default from `../000_creds/seats.json`)
- `CREATE_DNS` - whether to create DNS records
- `CREATE_TLS` - whether to create TLS certificates
- `PROVIDER_NAME` - cloud provider to use (default from `../.env.mk`)

For example:

```shell
make apply REMOTE_STATE=false SEAT_COUNT=1 CREATE_DNS=true CREATE_TLS=false PROVIDER_NAME=scaleway
```

Proceed to [003_vscode](../003_kubernetes/)