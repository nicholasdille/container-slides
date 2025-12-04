#!/bin/bash
set -o errexit

REF_SNAPSHOT=""
for SNAPSHOT in $(find 160_gitlab_ci -type d -name snapshot | sort); do

    if test -n "${REF_SNAPSHOT}"; then
        diff -u "${REF_SNAPSHOT}" "${SNAPSHOT}" | less
    fi

    REF_SNAPSHOT="${SNAPSHOT}"
done