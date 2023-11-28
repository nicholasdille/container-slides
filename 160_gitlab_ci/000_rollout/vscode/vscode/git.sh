#!/bin/bash

if test -z "${GIT_USER}" || test -z "${GIT_EMAIL}" || test -z "${GIT_CRED}"; then
    echo "ERROR: Missing environment variables GIT_USER, GIT_EMAIL, GIT_CRED."
    exit 1
fi

git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_EMAIL}"
git config --global credential.helper store
echo "${GIT_CRED}" >.git-credentials

git clone "https://gitlab.inmylab.de/${GIT_USER}/demo" /home/seat/demo
git -C /home/seat/demo remote add upstream https://github.com/nicholasdille/container-slides
