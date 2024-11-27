#!/bin/bash
set -o errexit -o pipefail

: "${SET_NAME:=$(date +%Y%m%d)}"
: "${COUNT:=1}"
: "${DOMAIN:=inmylab.de}"

function generate_code() {
    local chars=(A B C D E F G H J K L M N P Q R S T U V W X Y Z 2 3 4 5 6 7 8 9)
    local length=6

    local max="${#chars[*]}"

    local code=""
    while test "${length}" -gt 0; do
        code="${code}${chars[$((RANDOM % max))]}"

        length=$((length - 1))
    done

    echo -n "${code}"
}

if ! test -f seats.json; then
    result="$(
        jq \
            --null-input \
            --arg name "${SET_NAME}" \
            --arg count "${COUNT}" \
            --arg domain "${DOMAIN}" \
            --arg gitlab_admin_password "$(openssl rand -hex 32)" \
            --arg gitlab_admin_token "glpat-$(openssl rand -hex 10)" \
            '
            {
                "name": $name,
                "count": $count,
                "domain": $domain,
                "gitlab_admin_password": $gitlab_admin_password,
                "gitlab_admin_token": $gitlab_admin_token,
                "seats": []
            }
            '
    )"

    for INDEX in $( seq 0 $(( COUNT - 1)) ); do
        result="$(
            echo "${result}" | jq \
                --arg index "${INDEX}" \
                --arg password "$(openssl rand -hex 32)" \
                --arg code "$(generate_code)" \
                --arg gitlab_token "glpat-$(openssl rand -hex 10)" \
                --arg webdav_pass_dev "$(openssl rand -hex 32)" \
                --arg webdav_pass_live "$(openssl rand -hex 32)" \
                '
                . as $all |
                $all.seats +=
                [{
                    "index": $index,
                    "password": $password,
                    "code": $code,
                    "gitlab_token": $gitlab_token,
                    "webdav_pass_dev": $webdav_pass_dev,
                    "webdav_pass_live": $webdav_pass_live
                }]
                '
        )"
    done
    echo "${result}" >seats.json
fi

UNIQUE_CODES_COUNT="$(
    jq --raw-output '.seats[].code' seats.json \
    | sort \
    | uniq \
    | wc -l
)"
if test "${UNIQUE_CODES_COUNT}" -ne "${COUNT}"; then
    echo "ERROR: Not all codes are unique."
    exit 1
fi

cat seats.json \
| jq --raw-output '
        .seats[] |
        "\nUser seat\(.index)\nCode \(.code)"
    ' \
>seats.txt
