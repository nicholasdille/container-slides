-include .env.mk

REPOSITORY_URL    := https://github.com/nicholasdille/terraform-state
REPOSITORY_BRANCH := main
TERRAFORM_BACKEND := terraform-backend-git git --repository $(REPOSITORY_URL) --ref $(REPOSITORY_BRANCH) --state demo/state.json

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

.terraform.lock.hcl: *.tf
	@\
	export TF_BACKEND_GIT_HTTP_USERNAME=$(GIT_USERNAME); \
	export TF_BACKEND_GIT_HTTP_PASSWORD=$(GIT_PASSWORD); \
	export GIT_USERNAME=$(GIT_USERNAME); \
	export GIT_PASSWORD=$(GIT_PASSWORD); \
	$(TERRAFORM_BACKEND) \
		terraform init -upgrade

.PHONY:
plan: plan.out

plan.out: *.tf .terraform.lock.hcl
	@\
	export TF_BACKEND_GIT_HTTP_USERNAME=$(GIT_USERNAME); \
	export TF_BACKEND_GIT_HTTP_PASSWORD=$(GIT_PASSWORD); \
	export GIT_USERNAME=$(GIT_USERNAME); \
	export GIT_PASSWORD=$(GIT_PASSWORD); \
	$(TERRAFORM_BACKEND) \
		terraform plan -out=plan.out -var="hcloud_token=$(HCLOUD_TOKEN)" -var="hetznerdns_token=$(HETZNERDNS_TOKEN)"

.PHONY:
apply: plan.out
	@\
	export TF_BACKEND_GIT_HTTP_USERNAME=$(GIT_USERNAME); \
	export TF_BACKEND_GIT_HTTP_PASSWORD=$(GIT_PASSWORD); \
	export GIT_USERNAME=$(GIT_USERNAME); \
	export GIT_PASSWORD=$(GIT_PASSWORD); \
	$(TERRAFORM_BACKEND) \
		terraform apply -auto-approve -state=terraform.tfstate plan.out
	@rm -f plan.out

.PHONY:
destroy:
	@\
	export TF_BACKEND_GIT_HTTP_USERNAME=$(GIT_USERNAME); \
	export TF_BACKEND_GIT_HTTP_PASSWORD=$(GIT_PASSWORD); \
	export GIT_USERNAME=$(GIT_USERNAME); \
	export GIT_PASSWORD=$(GIT_PASSWORD); \
	$(TERRAFORM_BACKEND) \
		terraform destroy -auto-approve -state=terraform.tfstate -var="hcloud_token=$(HCLOUD_TOKEN)" -var="hetznerdns_token=$(HETZNERDNS_TOKEN)"
	@rm -f terraform.tfstate*
