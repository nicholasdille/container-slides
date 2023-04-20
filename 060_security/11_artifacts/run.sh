#!/bin/bash
set -o errexit

if test "$(docker container ls --all --filter status=exited --filter name=registry | wc -l)" -gt 1; then
    docker container rm registry
fi
if test "$(docker container ls --filter name=registry | wc -l)" -eq 1; then
    # TODO: Use OCI 1.1 compliant registry (https://github.com/oras-project/distribution/pkgs/container/registry)
    docker container run --detach --name registry --publish 127.0.0.1:5000:5000 registry
fi
regctl registry set 127.0.0.1:5000 --tls disabled

IMAGE=127.0.0.1:5000/ubuntu:22.04
docker pull ubuntu:22.04
docker tag ubuntu:22.04 "${IMAGE}"
docker push "${IMAGE}"

trivy image "${IMAGE}" --format cyclonedx --output cyclonedx.json
cat cyclonedx.json \
| regctl artifact put --subject "${IMAGE}" \
    --artifact-type application/vnd.cyclonedx+json \
    --file-media-type cyclonedx.json \
    --annotation "created-by=trivy" \
    --annotation "created=$(date -Iseconds)"
#cat cyclonedx.json \
#| trivy referrer put
#oras push "${IMAGE}" \
#    --artifact-type 'signature/example' \
#    --subject "${IMAGE}" \
#    ./cyclonedx.json:application/vnd.cyclonedx+json
trivy image "${IMAGE}" --format sarif \
| trivy referrer put

trivy referrer list "${IMAGE}"
trivy referrer list "${IMAGE}" --format table
regctl artifact list "${IMAGE}"
regctl artifact tree "${IMAGE}"
oras discover "${IMAGE}" --plain-http --output tree

trivy image "${IMAGE}" --sbom-sources oci

if test -z "${COSIGN_PASSWORD}"; then
    echo "ERROR: You must set COSIGN_PASSWORD"
    exit 1
fi
if ! test -f ./cosign.key; then
    cosign generate-key-pair
fi
COSIGN_KEY=./cosign.key
COSIGN_PUB=./cosign.pub
COSIGN_EXPERIMENTAL=1 cosign sign -y --key "${COSIGN_KEY}" --registry-referrers-mode oci-1-1 "${IMAGE}"

SOURCE_CYCLONEDX="$(
    regctl artifact tree --filter-artifact-type application/vnd.cyclonedx+json "${IMAGE}" --format "{{json .}}" \
    | jq -r '.referrer | .[0].reference.Digest'
)"
#SOURCE_CYCLONEDX="$(
#    oras discover "${IMAGE}" \
#        --plain-http \
#        --output json \
#        --artifact-type application/vnd.cyclonedx+json \
#    | jq -r ".references[0].digest"
#)"
COSIGN_EXPERIMENTAL=1 cosign sign -y --key "${COSIGN_KEY}" --registry-referrers-mode oci-1-1 "${IMAGE}@${SOURCE_CYCLONEDX}"

SOURCE_SARIF="$(
    regctl artifact tree --filter-artifact-type application/sarif+json "${IMAGE}" --format "{{json .}}" \
    | jq -r '.referrer | .[0].reference.Digest'
)"
COSIGN_EXPERIMENTAL=1 cosign sign -y --key "${COSIGN_KEY}" --registry-referrers-mode oci-1-1 "${IMAGE}@${SOURCE_SARIF}"

regctl artifact list "${IMAGE}"

cosign verify --key "${COSIGN_PUB}" "${IMAGE}"
cosign verify --key "${COSIGN_PUB}" "${IMAGE}@${SOURCE_CYCLONEDX}"
cosign verify --key "${COSIGN_PUB}" "${IMAGE}@${SOURCE_SARIF}"