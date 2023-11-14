#!/bin/bash
set -o errexit

echo
echo "--------------------------------------------------"
echo "Starting container registry..."
docker container run --detach --name registry --publish 127.0.0.1:5000:5000 ghcr.io/oras-project/registry:v1.0.0-rc.4

echo
echo "--------------------------------------------------"
echo "Configure regctl for registry..."
regctl registry set 127.0.0.1:5000 --tls=disabled

echo
echo "--------------------------------------------------"
echo "Build and push image..."
docker build --quiet --tag localhost:5000/ubuntu:22.04 --provenance=false --output=type=registry,oci-mediatypes=true .
DIGEST="$(regctl manifest head 127.0.0.1:5000/ubuntu:22.04)"

echo
echo "--------------------------------------------------"
echo "Check if referrers are supported..."
if curl -sfo /dev/null "http://127.0.0.1:5000/v2/ubuntu/referrers/${DIGEST}"; then
    echo "Referrers are supported!"
fi

echo
echo "--------------------------------------------------"
echo "Create SBOM for image..."
trivy --quiet image 127.0.0.1:5000/ubuntu:22.04 --format cyclonedx --output cyclonedx.json

echo
echo "--------------------------------------------------"
echo "Push SBOM as artifact..."
regctl artifact put \
    --file cyclonedx.json \
    --subject 127.0.0.1:5000/ubuntu:22.04 \
    --artifact-type application/vnd.cyclonedx+json \
    --annotation "created-by=trivy" \
    --annotation "org.opencontainers.artifact.created=$(date -Iseconds)" \
    --annotation "org.opencontainers.artifact.description=CycloneDX JSON SBOM"

echo
echo "--------------------------------------------------"
echo "Current state of artifact tree:"
regctl artifact list 127.0.0.1:5000/ubuntu:22.04
read

echo
echo "--------------------------------------------------"
echo "Create SARIF report..."
trivy --quiet image 127.0.0.1:5000/ubuntu:22.04 --format sarif --output sarif.json

echo
echo "--------------------------------------------------"
echo "Push SARIF report as artifact..."
regctl artifact put \
    --file sarif.json \
    --subject 127.0.0.1:5000/ubuntu:22.04 \
    --artifact-type application/sarif+json \
    --annotation "created-by=trivy" \
    --annotation "org.opencontainers.artifact.created=$(date -Iseconds)" \
    --annotation "org.opencontainers.artifact.description=SARIF JSON"

echo
echo "--------------------------------------------------"
echo "Current state of artifact tree:"
regctl artifact list 127.0.0.1:5000/ubuntu:22.04
read

echo
echo "--------------------------------------------------"
echo "Create temporary cosign key pair..."
rm cosign.key cosign.pub
export COSIGN_PASSWORD="$(openssl rand -hex 32)"
cosign generate-key-pair

echo
echo "--------------------------------------------------"
echo "Sign image..."
COSIGN_EXPERIMENTAL=1 cosign sign --yes --key=cosign.key --registry-referrers-mode=oci-1-1 127.0.0.1:5000/ubuntu:22.04

echo
echo "--------------------------------------------------"
echo "Sign SBOM..."
DIGEST_SBOM="$(
    regctl artifact tree 127.0.0.1:5000/ubuntu:22.04 --format "{{json .}}" \
    | jq --raw-output \
        '
            .referrer[] |
            select(.manifest.artifactType == "application/vnd.cyclonedx+json") |
            .reference.Digest
        '
)"
COSIGN_EXPERIMENTAL=1 cosign sign --yes --key=cosign.key --registry-referrers-mode=oci-1-1 "127.0.0.1:5000/ubuntu:22.04@${DIGEST_SBOM}"

echo
echo "--------------------------------------------------"
echo "Current state of artifact tree:"
regctl artifact tree 127.0.0.1:5000/ubuntu:22.04
read

echo
echo "--------------------------------------------------"
echo "Sign SARIF report..."
DIGEST_SARIF="$(
    regctl artifact tree 127.0.0.1:5000/ubuntu:22.04 --format "{{json .}}" \
    | jq --raw-output \
        '
            .referrer[] |
            select(.manifest.artifactType == "application/sarif+json") |
            .reference.Digest
        '
)"
COSIGN_EXPERIMENTAL=1 cosign sign --yes --key=cosign.key --registry-referrers-mode=oci-1-1 "127.0.0.1:5000/ubuntu:22.04@${DIGEST_SARIF}"

echo
echo "--------------------------------------------------"
echo "Current state of artifact tree:"
regctl artifact tree 127.0.0.1:5000/ubuntu:22.04
read

echo
echo "--------------------------------------------------"
echo "Get SBOM artifact..."
regctl artifact get "127.0.0.1:5000/ubuntu@${DIGEST_SBOM}" | jless

echo
echo "--------------------------------------------------"
echo "Inspect manifest for SBOM artifact..."
regctl manifest get "127.0.0.1:5000/ubuntu@${DIGEST_SBOM}" --format "{{json .}}" | jless
