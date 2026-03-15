TRAEFIK_PASSWORD := $(shell openssl rand -hex 16)

infrastructure.json: ../002_hcloud/infrastructure.json
	@jq --arg password "$(TRAEFIK_PASSWORD)" '.traefik_password = $$password' ../002_hcloud/infrastructure.json >$@
