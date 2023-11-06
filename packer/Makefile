-include .env.mk

.PHONY:
init:
	@packer init .

.PHONY:
build: init
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build .