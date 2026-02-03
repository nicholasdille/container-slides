#!/bin/bash
set -o errexit

if ! test -d kubernetes-src; then
    mkdir -p kubernetes-src
    curl -sSLf https://distro.eks.amazonaws.com/kubernetes-1-34/kubernetes-1-34-eks-13.yaml \
    | yq '.status.components[] | select(.name == "kubernetes") | .assets[] | select(.name == "kubernetes-src.tar.gz") | .archive.uri' \
    | xargs curl -sSLf \
    | tar -xzC kubernetes-src
fi

cd kubernetes-src

source hack/lib/version.sh
kube::version::get_version_vars
KUBE_GIT_VERSION=${KUBE_GIT_VERSION} kind build node-image --image eks-d:${KUBE_GIT_VERSION} .

echo "NEXT: kind create cluster --name eks-d-test --image eks-d:${KUBE_GIT_VERSION}"
