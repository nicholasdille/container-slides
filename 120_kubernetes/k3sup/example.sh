#!/bin/bash
set -o errexit

VM_BASE_NAME=k3sup

HCLOUD_IMAGE=ubuntu-18.04
HCLOUD_LOCATION=fsn1
HCLOUD_SSH_KEY=209622
HCLOUD_TYPE=cx21

check_network() {
    test "$(hcloud network list --selector k3sup=true | wc -l)" == "2"
}

create_network() {
    local NAME=$1
    local IPS=$2
    local LABELS=$3

    hcloud network create \
        --name ${NAME} \
        --ip-range ${IPS} \
        --label ${LABELS}

    hcloud network add-subnet k3sup \
        --network-zone eu-central \
        --type server \
        --ip-range 10.0.0.0/16
}

check_vm() {
    local TYPE=$1
    local INDEX=$2

    test "$(hcloud server list --selector k3sup=true,type=${TYPE},index=${INDEX} | wc -l)" == "2"
}

create_vm() {
    local NAME=$1
    local NETWORK=$2
    local LABELS=$3

    hcloud server create \
        --name ${NAME} \
        --location ${HCLOUD_LOCATION} \
        --image ${HCLOUD_IMAGE} \
        --ssh-key ${HCLOUD_SSH_KEY} \
        --type ${HCLOUD_TYPE} \
        --network ${NETWORK} \
        --label ${LABELS}
}

label_vm() {
    local HCLOUD_VM_NAME=$1
    local LABEL=$2

    hcloud server add-label ${HCLOUD_VM_NAME} ${LABEL}
}

build() {
    if ! check_network; then
        echo "Creating network..."
        create_network k3sup 10.0.0.0/8 k3sup=true
    fi

    echo "Creating first master"
    if ! check_vm master 1; then
        create_vm ${VM_BASE_NAME}-master-01 k3sup k3sup=true,type=master,index=1
    fi

    echo "Deploying k3s"
    SSH_IP=$(hcloud server list --selector k3sup=true,type=master,index=1 --output json | jq --raw-output '.[].public_net.ipv4.ip')
    k3sup install --ip ${SSH_IP} --ssh-key ~/id_rsa_hetzner --k3s-extra-args '--no-deploy servicelb,traefik'
}

destroy() {
    hcloud server list --selector k3sup=true --output json | jq --raw-output '.[].name' | xargs hcloud server delete
    hcloud network delete k3sup
}

case "$1" in
    build)
        build
    ;;
    destroy)
        destroy
    ;;
    what)
        echo "$0 build|destroy"
    ;;
    say)
        echo "say WHAT"
    ;;
    *)
        echo "say what?!"
        exit 1
    ;;
esac
