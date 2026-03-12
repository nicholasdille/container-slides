#!/bin/bash
set -o errexit -o pipefail

: "${SET_NAME:=$(date +%Y%m%d)}"
: "${COUNT:=1}"
: "${DOMAIN:=inmylab.de}"

if test -f seats.json; then
    echo "ERROR: Output file seats.json already exists."
    exit 1
fi

result="$(
    jq \
        --null-input \
        --arg name "${SET_NAME}" \
        --arg count "${COUNT}" \
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

for INDEX in $( seq 0 $(( COUNT - 1)) ); do
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
