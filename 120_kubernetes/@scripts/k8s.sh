#!/bin/bash
set -o errexit

BASE=$1
if test -z "${BASE}"; then
    echo "Usage: $0 <base-url> <target-directory>"
    exit 1
fi
TARGET=$2
if test -z "${TARGET}"; then
    echo "Usage: $0 <base-url> <target-directory>"
    exit 1
fi
if ! test -d "${TARGET}"; then
    echo "ERROR: Target directory ${TARGET} does not exist."
    exit 1
fi
#if test -d "${TARGET}/slides" || test -d "${TARGET}/exercises"; then
#    echo "ERROR: Target directory ${TARGET} already contains slides/ or exercises/."
#    exit 1
#fi

TEMP=$(mktemp -d)
trap "rm -rf ${TEMP}" EXIT

if ! test -d "${TEMP}/slides/.git"; then
    echo "${TEMP}/slides/ is not a git repository. Cloning..."
    git clone "${BASE}/slides" "${TEMP}/slides"
else
    echo "${TEMP}/slides/ is already a git repository. Pulling latest changes..."
    git -C "${TEMP}/slides/" pull
fi

if ! test -d "${TEMP}/exercises/.git"; then
    echo "${TEMP}/exercises/ is not a git repository. Cloning..."
    git clone "${BASE}/exercises" "${TEMP}/exercises"
else
    echo "${TEMP}/exercises/ is already a git repository. Pulling latest changes..."
    git -C "${TEMP}/exercises/" pull
fi

mkdir -p "${TARGET}"

rsync -a "${TEMP}/slides/slides/" "${TARGET}/slides/"
mkdir -p "${TARGET}/slides/media"
cp \
    "${TEMP}/slides/media/kubernetes.svg" \
    "${TEMP}/slides/media/cncf.svg" \
    "${TEMP}/slides/media/docker.svg" \
    "${TEMP}/slides/media/podman.svg" \
    "${TEMP}/slides/media/podinfo.png" \
    "${TARGET}/slides/media"
rm -f \
    "${TARGET}/slides/events.md" \
    "${TARGET}/slides/feedback.md" \
    "${TARGET}/slides/support.md" \
    "${TARGET}/slides/who.md"
find "${TARGET}/slides" -type f -name \*.md | while read -r FILE; do
    echo "Patching image links in ${FILE}"
    sed -i 's|](slides/|](120_kubernetes/slides/|g' "${FILE}"
    sed -i 's|src="slides/|src="120_kubernetes/slides/|g' "${FILE}"

    echo "Patching media links in ${FILE}"
    sed -i 's|](media/|](120_kubernetes/slides/media/|g' "${FILE}"
    echo "Patching vscode links in ${FILE}"
    sed -i 's|code-N|seatN|g; s|labs.haufedev.systems|vscode.inmylab.de|g' "${FILE}"
done

rsync -a "${TEMP}/exercises/hands-on/docs/exercises/" "${TARGET}/exercises/"
find "${TARGET}/exercises" -type f -name \*.md | while read -r FILE; do
    echo "Patching internal links in ${FILE}"
    sed -i 's|http://devinfra.gitlab.haufedev.systems/internals/eventreihe/kubernetes-workshop||g' "${FILE}"
    sed -i 's|https://devinfra.gitlab.haufedev.systems/internals/eventreihe/kubernetes-workshop||g' "${FILE}"

    echo "Patching external links in ${FILE}"
    sed -i 's|{:target="_blank"}||g' "${FILE}"

    echo "Patching vscode links in ${FILE}"
    sed -i 's|code-N|seatN|g; s|code-0|seat0|g; s|labs.haufedev.systems|vscode.inmylab.de|g' "${FILE}"

    echo "Patching serices in ${FILE}"
    sed -i 's|devops-k8s-workshop.registry.haufedev.systems|registry.inmylab.de|g' "${FILE}"
    sed -i 's|loki.dev.maas.haufedev.systems|loki.inmylab.de|g' "${FILE}"
done
find "${TARGET}/exercises" -type f -name \*.svg | while read -r FILE; do
    echo "Patching vscode links in ${FILE}"
    sed -i 's|code-N|seatN|g; s|labs.haufedev.systems|vscode.inmylab.de|g' "${FILE}"
done
