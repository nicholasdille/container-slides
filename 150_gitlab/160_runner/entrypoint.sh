#!/bin/bash
set -o errexit

# REQUIRED: Registration token from runners page
if test -z "${REGISTRATION_TOKEN}"; then
    echo "ERROR: Registration token must be supplied in REGISTRATION_TOKEN."
    exit 1
fi

# PREDEFINED: All projects can use the runner
: "${REGISTER_LOCKED:=false}"
export REGISTER_LOCKED

# PREDEFINED: Runner accepts jobs without tags
: "${REGISTER_RUN_UNTAGGED:=true}"
export REGISTER_RUN_UNTAGGED

# PREDEFINED: Tags for runner
: "${RUNNER_TAG_LIST:=docker}"
export RUNNER_TAG_LIST

gitlab-runner register --non-interactive
exec gitlab-runner run --user gitlab-runner