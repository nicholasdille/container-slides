#!/bin/bash
set -o errexit

uniget install \
    kind \
    kubectl \
    helm \
    jq

kind create cluster
