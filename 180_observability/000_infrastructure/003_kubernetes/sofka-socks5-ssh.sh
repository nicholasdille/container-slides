#!/bin/bash
set -o errexit

if ! test -f ../002_infrastructure/infrastructure.json; then
    echo "ERROR: Unable to find ../002_infrastructure/infrastructure.json."
    exit 1
fi
SEAT_COUNT="$( jq --raw-output '.count' ../002_infrastructure/infrastructure.json )"

KUBECONFIGS=()
PIDS=()
for INDEX in $( seq 0 $(( SEAT_COUNT - 1)) ); do
    KUBECONFIG_FILE=kubeconfig.k8s${INDEX}
    KUBECONFIG_FILE_SOCKS5="${KUBECONFIG_FILE}.socks5"
    SOCKS5_PORT=$(( 1080 + INDEX ))

    cp "${KUBECONFIG_FILE}" "${KUBECONFIG_FILE_SOCKS5}"
    KUBECONFIG="${KUBECONFIG_FILE_SOCKS5}" kubectl config set clusters.kind-seat${INDEX}.proxy-url "socks5://127.0.0.1:${SOCKS5_PORT}"

    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -f -N -D ${SOCKS5_PORT} k8s${INDEX} &

    KUBECONFIGS+=("${KUBECONFIG_FILE_SOCKS5}")
done

KUBECONFIG=$(IFS=:; echo "${KUBECONFIGS[*]}")
export KUBECONFIG
echo "KUBECONFIG set to: $KUBECONFIG"

#read -p "Press enter to start sofka..."
sofka

#read -p "Press enter to exit and kill SSH tunnels..."
netstat -tunapl 2>/dev/null | grep -v tcp6 | grep LISTEN | grep "ssh" | tr -s ' ' | cut -d' ' -f7 | cut -d/ -f1 | xargs -r kill
