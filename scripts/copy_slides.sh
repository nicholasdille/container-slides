#!/bin/bash
set -o errexit

extract_links() {
    cat | while read LINE; do
        echo ${LINE} | grep -E "!\[.*\]\([^)]+\)" | sed -r 's/^.*!\[.*\]\(([^)]+)\).*$/\1/'
        echo ${LINE} | grep "<img " | sed -r 's/^.*img.+src="([^"]+)".+$/\1/'
    done
}
extract_from_comments() {
    cat | while read LINE; do
        echo ${LINE} | grep "data-background=" | sed -r 's/^.+\sdata-background="([^"]+)".*$/\1/'
    done
}
copy_to_target() {
    cat | while read LINK; do
        echo "### Copy <${LINK}>"
        cp --parents "${LINK}" "${TARGET}"
    done
}

FILE=${1}
if [[ -z "${FILE}" ]] || [[ ! -f "${FILE}" ]]; then
    FILE=$(ls $(date +%Y-%m-%d)* 2>/dev/null)
fi
if [[ -z "${FILE}" ]]; then
    echo Unable to determine file
    exit 1
fi

TARGET=${2}
if [[ -z "${TARGET}" ]]; then
    echo Unable to determine target directory
    exit 1
fi
if [[ ! -d "${TARGET}" ]]; then
    mkdir -p "${TARGET}"
fi

if ! type make; then
    apt -y install make
fi
if ! type xmlstarlet; then
    apt -y install xmlstarlet
fi

make || true

echo "${FILE}" | copy_to_target

REVEALJS_VERSION="$( npm list --json | jq --raw-output '.dependencies | to_entries[] | select(.key == "reveal.js") | .value.version' )"
SOURCE_SANS_VERSION="$( npm list --json | jq --raw-output '.dependencies | to_entries[] | select(.key == "@fontsource/source-sans-3") | .value.version' )"
HIGHLIGHTJS_VERSION="$( npm list --json | jq --raw-output '.dependencies | to_entries[] | select(.key == "highlight.js") | .value.version' )"
FONTAWESOME_VERSION="$( npm list --json | jq --raw-output '.dependencies | to_entries[] | select(.key == "@fortawesome/fontawesome-pro") | .value.version' )"
sed -E -i "s|node_modules/reveal.js/|https://cdn.dille.name/reveal.js@${REVEALJS_VERSION}/|" "${TARGET}/${FILE}"
sed -E -i "s|node_modules/@fontsource/source-sans-3/|https://cdn.dille.name/source-sans-3@${SOURCE_SANS_VERSION}/|" "${TARGET}/${FILE}"
sed -E -i "s|node_modules/highlight.js/|https://cdn.dille.name/highlight.js@${HIGHLIGHTJS_VERSION}/|" "${TARGET}/${FILE}"
sed -E -i "s|node_modules/@fortawesome/fontawesome-pro/|https://cdn.dille.name/fontawesome-pro@${FONTAWESOME_VERSION}/|" "${TARGET}/${FILE}"

xmlstarlet sel -N x="http://www.w3.org/1999/xhtml" -t -m "//x:textarea" -v . "${TARGET}/${FILE}" \
| extract_links \
| copy_to_target
xmlstarlet sel -N x="http://www.w3.org/1999/xhtml" -t -m "//x:section/@data-background" -v . -n "${TARGET}/${FILE}" \
| copy_to_target
xmlstarlet sel -N x="http://www.w3.org/1999/xhtml" -t -m "//x:img/@src" -v . -n "${TARGET}/${FILE}" \
| copy_to_target
xmlstarlet sel -N x="http://www.w3.org/1999/xhtml" -t -m "//x:textarea/comment()" -v . -n "${TARGET}/${FILE}" \
| extract_from_comments \
| copy_to_target
xmlstarlet sel -N x="http://www.w3.org/1999/xhtml" -t -v "//x:link/@href" -n "${TARGET}/${FILE}" \
| grep -v '^https://' \
| copy_to_target

INCLUDES=$(
    xmlstarlet sel -N x="http://www.w3.org/1999/xhtml" -t -m "//x:section/@data-markdown" -v . -n "${TARGET}/${FILE}" \
    | grep -vE "^\s*$"
)
for INCLUDE in ${INCLUDES}; do
    echo "${INCLUDE}" \
    | copy_to_target
    cat ${INCLUDE} \
    | extract_links \
    | copy_to_target
done

mv "${TARGET}/${FILE}" "${TARGET}/index.html"
