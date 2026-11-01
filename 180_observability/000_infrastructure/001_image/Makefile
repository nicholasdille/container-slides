include ../.env.mk

.PHONY:
docker:
	@packer init docker.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build -only=$(PROVIDER_NAME).uniget docker.pkr.hcl
