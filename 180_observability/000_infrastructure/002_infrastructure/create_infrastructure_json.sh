#!/bin/bash
set -o errexit

if ! test -f ../000_creds/seats.json; then
    echo "ERROR: Unable to find seats.json"
    exit 1
fi
if ! test -f ips.txt; then
    echo "ERROR: Unable to find ips.txt"
    exit 1
fi

readarray -t ips <ips.txt

: "${EVENT_NAME:=$( jq --raw-output '.name' ../000_creds/seats.json )}"
: "${SEAT_COUNT:=${#ips[@]}}"
: "${DOMAIN:=$( jq --raw-output '.domain' ../000_creds/seats.json )}"

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
    IP="${ips[${INDEX}]}"
    PASSWORD="$( jq --raw-output --arg index "${INDEX}" '.seats[] | select(.index == $index) | .password' ../000_creds/seats.json )"

    result="$(
        echo "${result}" | jq \
            --arg index "${INDEX}" \
            --arg password "${PASSWORD}" \
            --arg ip "${IP}" \
            '
            . as $all |
            $all.seats +=
            [{
                "index": $index,
                "password": $password,
                "ip": $ip
            }]
            '
    )"
done
echo "${result}"
