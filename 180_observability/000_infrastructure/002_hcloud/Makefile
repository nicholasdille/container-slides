include ../.env.mk

REPOSITORY_URL         := https://github.com/nicholasdille/terraform-state
REPOSITORY_BRANCH      := main
SEATS_JSON_FILE        := ../000_creds/seats.json
STATE_NAME             := $(shell jq --raw-output '.name' $(SEATS_JSON_FILE))
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
		-out=$@ \
		-var="event_name=$(STATE_NAME)" \
		-var="seat_count=$(USER_COUNT)" \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hcloud_dns_token=$(HCLOUD_TOKEN_DNS)"

.PHONY:
apply: plan.out
	@\
	$(TERRAFORM_WITH_BACKEND) apply -auto-approve plan.out
	@rm -f plan.out

state.json:
	@\
	$(TERRAFORM_WITH_BACKEND) state pull >$@

.PHONY:
state: state.json

.PHONY:
destroy:
	@\
	$(TERRAFORM_WITH_BACKEND) destroy \
		-auto-approve \
		-var="event_name=$(STATE_NAME)" \
		-var="seat_count=$(USER_COUNT)" \
		-var="hcloud_token=$(HCLOUD_TOKEN)" \
		-var="hcloud_dns_token=$(HCLOUD_TOKEN_DNS)"
	@rm -f terraform.tfstate*
