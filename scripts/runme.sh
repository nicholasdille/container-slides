function require() {
    local command=$1

    if ! command -v $command > /dev/null; then
        echo "Command not found: ${command}"
    fi
}

require runme
require jq
require column

function runme_list() {
    local file=$1

    if test -z $file; then
        echo "Usage: runme_demo <file>"
        return 1
    fi
    if ! test -f $file; then
        echo "File not found: ${file}"
        return 1
    fi

    runme --filename "${file}" list --json \
    | jq --raw-output '.[] | "\(.name);\(.description)"' \
    | column --table --separator ';' --table-columns 'Name,Description'
}

function runme_show() {
    local file=$1
    local name=$2

    if test -z "${file}"; then
        echo "Usage: runme_show <file> <name>"
        return 1
    fi
    if ! test -f "${file}"; then
        echo "File not found: ${file}"
        return 1
    fi

    if test -z "${name}"; then
        echo "Usage: runme_show <file> <name>"
        return 1
    fi

    runme --filename "${file}" print "${name}" | glow
}

function runme_demo() {
    local file=$1
    local name=$2

    if test -z "${file}"; then
        echo "Usage: runme_show <file> <name>"
        return 1
    fi
    if ! test -f "${file}"; then
        echo "File not found: ${file}"
        return 1
    fi

    if test -z "${name}"; then
        echo "Usage: runme_show <file> <name>"
        return 1
    fi

    runme --filename "${file}" run "${name}"
}