include .env.mk

REPOSITORY_URL         := https://github.com/nicholasdille/terraform-state
REPOSITORY_BRANCH      := main
STATE_NAME             := 160_gitlab_ci
TERRAFORM_WITH_BACKEND := TF_BACKEND_GIT_HTTP_USERNAME=$(GIT_USERNAME) TF_BACKEND_GIT_HTTP_PASSWORD=$(GIT_PASSWORD) GIT_USERNAME=$(GIT_USERNAME) GIT_PASSWORD=$(GIT_PASSWORD) terraform-backend-git git --repository $(REPOSITORY_URL) --ref $(REPOSITORY_BRANCH) --state $(STATE_NAME)/state.json terraform

.PHONY:
clean:
	@rm -rf plan.out terraform.tfstate* ssh ssh.pub .terraform*

.PHONY:
show:
	@terraform show

.PHONY:
output:
	@terraform output

.PHONY:
init: .terraform.lock.hcl

.PHONY:
init-reconfigure:
	@\
	$(TERRAFORM_WITH_BACKEND) init -reconfigure

.PHONY:
init-migrate-state:
	@\
	$(TERRAFORM_WITH_BACKEND) init -migrate-state

.terraform.lock.hcl: *.tf
	@\
	$(TERRAFORM_WITH_BACKEND) init -upgrade

.PHONY:
plan: plan.out

plan.out: *.tf .terraform.lock.hcl
	@\
	$(TERRAFORM_WITH_BACKEND) plan \
		-out=plan.out \
		-var="name=$(STATE_NAME)" \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hetznerdns_token=$(HETZNERDNS_TOKEN)"

.PHONY:
apply: plan.out
	@\
	$(TERRAFORM_WITH_BACKEND) apply -auto-approve -state=terraform.tfstate plan.out
	@rm -f plan.out

.PHONY:
destroy:
	@\
	$(TERRAFORM_WITH_BACKEND) destroy \
		-auto-approve \
		-state=terraform.tfstate \
		-var="name=$(STATE_NAME)" \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hetznerdns_token=$(HETZNERDNS_TOKEN)"
	@rm -f terraform.tfstate*

.PHONY:
uniget:
	@packer init uniget.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build uniget.pkr.hcl

.PHONY:
docker:
	@packer init docker.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build docker.pkr.hcl

.PHONY:
gitlab:
	@packer init gitlab.pkr.hcl
	@HCLOUD_TOKEN="$(HCLOUD_TOKEN)" packer build gitlab.pkr.hcl
