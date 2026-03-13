#!/bin/bash
set -o errexit -o pipefail

: "${EVENT_NAME:=$(date +%Y%m%d)}"
: "${SEAT_COUNT:=1}"
: "${DOMAIN:=inmylab.de}"

if test -f seats.json; then
    echo "ERROR: Output file seats.json already exists."
    exit 1
fi

result="$(
    jq \
        --null-input \
        --arg name "${EVENT_NAME}" \
        --arg count "${SEAT_COUNT}" \
        --arg domain "${DOMAIN}" \
        '
        {
            "name": $name,
            "count": $count,
            "domain": $domain,
            "seats": []
        }
        '
)"

for INDEX in $( seq 0 $(( SEAT_COUNT - 1)) ); do
    result="$(
        echo "${result}" | jq \
            --arg index "${INDEX}" \
            --arg password "$(openssl rand -hex 8)" \
            '
            . as $all |
            $all.seats +=
            [{
                "index": $index,
                "password": $password
            }]
            '
    )"
done
echo "${result}" >seats.json
