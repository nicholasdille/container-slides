# Deployment guide

Fill `.env.mk` following this template:

```shell
HCLOUD_TOKEN     := XXX
HCLOUD_TOKEN_DNS := YYY

SCALEWAY_PROJECT_ID := xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
SCALEWAY_ACCESS_KEY := AAA
SCALEWAY_TOKEN      := XXX

PROVIDER_NAME := scaleway # or hcloud

GIT_USERNAME := nicholasdille
GIT_PASSWORD := PPP # GitHub personal access token for remote terraform state
```

Proceed to [000_creds](000_creds)