#!/bin/bash
set -o errexit -o pipefail

cp /etc/nginx/conf.d/default.conf /tmp/default.conf
cat /tmp/default.conf \
| envsubst \
>/etc/nginx/conf.d/default.conf
