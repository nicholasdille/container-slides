#!/bin/bash
set -o errexit

# REQUIRED: Registration token from runners page
if test -z "${REGISTRATION_TOKEN}"; then
    echo "ERROR: Registration token must be supplied in REGISTRATION_TOKEN."
    exit 1
fi

# PREDEFINED: URL of the GitLab server
: "${CI_SERVER_URL:=http://gitlab}"
export CI_SERVER_URL

# PREDEFINED: Executor type
: "${RUNNER_EXECUTOR:=shell}"
export RUNNER_EXECUTOR

# PREDEFINED: All projects can use the runner
: "${REGISTER_LOCKED:=false}"
export REGISTER_LOCKED

# PREDEFINED: Runner accepts jobs without tags
: "${REGISTER_RUN_UNTAGGED:=true}"
export REGISTER_RUN_UNTAGGED

# PREDEFINED: Tags for runner
: "${RUNNER_TAG_LIST:=docker}"
export RUNNER_TAG_LIST

# PREDEFINED: Docker image
: "${DOCKER_IMAGE:=alpine}"
export DOCKER_IMAGE

# PREDEFINED: Concurrent jobs
: "${CONCURRENT:=1}"
export CONCURRENT

echo "### UNREGISTER"
gitlab-runner unregister --all-runners

echo "### REGISTERING"
gitlab-runner register --non-interactive
sed -i "s/concurrent.*/concurrent = ${CONCURRENT}/" /etc/gitlab-runner/config.toml
cat /etc/gitlab-runner/config.toml

echo "### STARTING"
exec gitlab-runner --debug run --user gitlab-runner