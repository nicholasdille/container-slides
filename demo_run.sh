#!/bin/bash
set -o errexit

. functions.sh

FILE=${1}
if [[ -z "${FILE}" ]] || [[ ! -f "${FILE}" ]]; then
    FILE=$(ls $(date +%Y-%m-%d)* 2>/dev/null)
fi
if [[ -z "${FILE}" ]]; then
    echo Unable to determine file
    exit 1
fi

if ! type make; then
    apt -y install make
fi
if ! type jq; then
    echo "Missing jq. Have you executed demo_prepare.sh on this machine?"
    exit 1
fi
if ! type xmlstarlet; then
    echo "Missing xmlstarlet. Have you executed demo_prepare.sh on this machine?"
    exit 1
fi
if ! type hcloud; then
    echo "Missing hcloud. Have you executed demo_prepare.sh on this machine?"
    exit 1
fi

echo
echo -e "${YELLOW}### Generating files${DEFAULT}"
make

INCLUDES=$(xmlstarlet sel -N x="http://www.w3.org/1999/xhtml" -t -m "//x:section/@data-markdown" -v . -n "${FILE}" | grep -vE '^$')
DIRS=$(for INCLUDE in ${INCLUDES}; do echo $(dirname ${INCLUDE}); done)

DIRS=$(echo "${DIRS}" | while read DIR; do if [[ "$(ls ${DIR}/*.demo 2>/dev/null)" != "" ]]; then echo ${DIR}; fi; done)

echo
echo -e "${YELLOW}Waiting for demo to start. Press enter to continue...${DEFAULT}"
read

for DIR in ${DIRS}; do
    pushd ${PWD}
    clear
    echo
    echo -e "${YELLOW}### Demo for ${DIR}${DEFAULT}"
    NAME=${DIR////-}
    NAME=${NAME//_/}
    if hcloud server list --selector demo=true,dir=${NAME} | grep --quiet "${NAME}"; then
        echo -e "${YELLOW}    VM ${NAME}${DEFAULT}"
    fi
    BASEDIR=$(pwd)
    cd "${PWD}/${DIR}"

    echo
    echo -e "${YELLOW}### Preparing demo${DEFAULT}"
    prepare

    echo
    echo -e "${YELLOW}### Ready for demo${DEFAULT}"
    export SET_PROMPT=1
    bash --init-file ${BASEDIR}/functions.sh
    unset SET_PROMPT

    echo
    echo -e "${YELLOW}### Cleaning up after demo${DEFAULT}"
    clean

    popd
done
