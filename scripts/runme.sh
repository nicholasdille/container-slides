function require() {
    local command=$1

    if ! command -v $command > /dev/null; then
        echo "Command not found: ${command}"
    fi
}

require runme
require jq
require column
require gum
require glow

function runme_find() {
    grep '^# ' *.runme.md \
    | sed -E 's/:# /;/' \
    | column --table --separator ';' --table-columns 'File,Description'
}

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

function runme_print() {
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

    runme --filename "${file}" print "${name}"
}

function runme_run() {
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

function runme_run() {
    local file=$1

    if test -z $file; then
        echo "Usage: runme_demo <file>"
        return 1
    fi
    if ! test -f $file; then
        echo "File not found: ${file}"
        return 1
    fi

    names="$(
        runme --filename "${file}" list --json \
        | jq --raw-output '.[].name'
    )"
    for name in $names; do
        gum style "${name}" --padding="1 0" --foreground=#7cbad4

        runme_print "${file}" "${name}" \
        | grep -v '^```' \
        | gum style --border=normal --padding="0 1"
        gum confirm "${name}" --affirmative=Execute --negative=Cancel --no-show-help || break

        runme_run "${file}" "${name}"
        echo
    done
}
