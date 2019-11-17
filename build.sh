#!/bin/bash

. functions.sh

DIRS=$(find . -type f -name \*.demo | xargs -n 1 dirname | uniq)
for DIR in ${DIRS}; do
    echo -e "${YELLOW}### Processing ${DIR}${DEFAULT}"

    (
        cd ${DIR}
        for FILE in $(ls *.demo); do
            DEMO=$(basename ${FILE} .demo)
            split ${DEMO}
        done
        include
    )
done