include ../000_rollout/.env.mk

REPOSITORY_URL         := https://github.com/nicholasdille/terraform-state
REPOSITORY_BRANCH      := main
STATE_NAME             := 160_gitlab_ci_gitlab
SEATS_JSON_FILE        := ../000_rollout/seats.json
GITLAB_TOKEN		   := $(shell jq --raw-output '.gitlab_admin_token' $(SEATS_JSON_FILE))
USER_COUNT   		   := $(shell jq --raw-output '.seats | length' $(SEATS_JSON_FILE))
TERRAFORM_WITH_BACKEND := TF_BACKEND_GIT_HTTP_USERNAME=$(GIT_USERNAME) TF_BACKEND_GIT_HTTP_PASSWORD=$(GIT_PASSWORD) GIT_USERNAME=$(GIT_USERNAME) GIT_PASSWORD=$(GIT_PASSWORD) terraform-backend-git git --repository $(REPOSITORY_URL) --ref $(REPOSITORY_BRANCH) --state $(STATE_NAME)/state.json terraform

.PHONY:
clean:
	@rm -rf plan.out terraform.tfstate* .terraform* git_http_backend.auto.tf

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
		-var="gitlab_token=$(GITLAB_TOKEN)" \
		-var="user_count=$(USER_COUNT)"

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
		-var="gitlab_token=$(GITLAB_TOKEN)" \
		-var="user_count=$(USER_COUNT)"
	@rm -f terraform.tfstate*

personal_access_tokens.json:
	@\
	$(TERRAFORM_WITH_BACKEND) output -json \
	| jq '.personal_access_tokens.value' \
	>personal_access_tokens.json

runner_token.json:
	@\
	$(TERRAFORM_WITH_BACKEND) output -json \
	| jq --raw-output '.runner_token.value' \
	>runner_token.json
