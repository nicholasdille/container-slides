## Quickstart <i class="fa-duotone fa-rocket-launch"></i>

Install `docker-setup`

```bash
curl --silent --location --output /usr/local/bin/docker-setup https://github.com/nicholasdille/docker-setup/releases/latest/download/docker-setup
chmod +x /usr/local/bin/docker-setup
docker-setup update
```

Discover tools

```bash
docker-setup list
docker-setup tags
docker-setup search docker
docker-setup describe docker
```

Install/update tools

```bash
docker-setup install gojq yq
docker-setup install --default --plan
```