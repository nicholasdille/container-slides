-include .env.mk

.PHONY:
uniget:
	@packer init uniget.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build uniget.pkr.hcl

.PHONY:
gitlab:
	@packer init gitlab.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build gitlab.pkr.hcl
