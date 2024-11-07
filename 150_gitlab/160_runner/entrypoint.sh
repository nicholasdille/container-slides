#!/bin/bash
set -o errexit

# REQUIRED: Registration token from runners page
if test -z "${CI_SERVER_TOKEN}"; then
    echo "ERROR: Registration token must be supplied in CI_SERVER_TOKEN."
    exit 1
fi

# PREDEFINED: URL of the GitLab server
: "${CI_SERVER_URL:=http://gitlab}"
export CI_SERVER_URL

# PREDEFINED: Executor type
: "${RUNNER_EXECUTOR:=shell}"
export RUNNER_EXECUTOR

# PREDEFINED: Docker image
: "${DOCKER_IMAGE:=alpine}"
export DOCKER_IMAGE

printenv

gitlab-runner register --non-interactive
exec gitlab-runner --debug run --user gitlab-runner