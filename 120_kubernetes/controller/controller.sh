#!/bin/bash
set -o errexit

if ! kubectl get replicaconfigs >/dev/null 2>&1; then
    echo "ERROR: Unable to find custom resource definition ReplicaConfigs."
    exit 1
fi

kubectl get replicaconfigs --all-namespaces --watch --output-watch-events --output json \
| while read -r EVENT; do
    event_type="$(echo "${EVENT}" | jq --raw-output '.type')"
    object_kind="$(echo "${EVENT}" | jq --raw-output '.object.kind')"
    object_name="$(echo "${EVENT}" | jq --raw-output '.object.metadata.name')"
    object_namespace="$(echo "${EVENT}" | jq --raw-output '.object.metadata.namespace')"

    echo "[${event_type}] ${object_kind} ${object_namespace}/${object_name}"

    kind="$(echo "${EVENT}" | jq --raw-output '.object.spec.kind')"
    name="$(echo "${EVENT}" | jq --raw-output '.object.spec.name')"
    replicas="$(echo "${EVENT}" | jq --raw-output '.object.spec.replicas')"

    echo "    +- ${kind}/${name}=${replicas}"

    if kubectl --namespace "${object_namespace}" get "${kind}" "${name}" >/dev/null 2>&1; then
        kubectl patch deployment nginx --patch "{\"spec\": {\"replicas\": ${replicas}}}"

    else
        echo "ERROR: Unable to find resource ${name} of kind ${kind} in namespace ${object_namespace}."
    fi
done