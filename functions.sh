if [[ "${SET_PROMPT}" == "1" ]]; then
    export PS1='\w $ '
    export PROMPT_DIRTRIM=2
fi

DEFAULT="\e[39m\e[49m"
LIGHT_GRAY="\e[37m"

DARK_GRAY="\e[90m"
RED="\e[91m"
GREEN="\e[92m"
YELLOW="\e[93m"
BLUE="\e[94m"
MAGENTA="\e[95m"
CYAN="\e[96m"

BG_DARKGRAY="\e[100m"
BG_RED="\e[101m"
BG_GREEN="\e[102m"
BG_YELLOW="\e[103m"
BG_BLUE="\e[104m"
BG_MAGENTA="\e[105m"
BG_CYAN="\e[106m"

demos() {
    DEMOS=$(ls -1 *.demo 2>/dev/null)
    if [[ -n "${DEMOS}" ]]; then
        echo
        echo "${DEMOS}" | while read FILE; do echo $(basename ${FILE} .demo): $(cat ${FILE} | head -n 1 | sed 's/^#\s*//'); done
        echo
    fi
}

ls *.demo 2>&1 >/dev/null && complete -W "$(ls *.demo | xargs -I{} basename {} .demo)" demo

demo() {
    if [[ "$#" == "0" ]]; then
        echo "Usage: $0 <demo_name>"
        return
    fi
    DEMO=${1}

    split ${DEMO}

    clear
    for COMMAND in $(ls ${DEMO}-*.command); do
        echo
        PREFIX="\$"
        cat ${COMMAND} | grep -vE '^\s*$' | sed 's|\\|\\\\|g' | while read; do
            if test "${REPLY:0:1}" == "#"; then
                # print comment
                echo -e "${LIGHT_GRAY}${REPLY} ${DEFAULT}"
            elif test "${REPLY: -1}" == "\\"; then
                echo -e "${PREFIX} ${GREEN}${REPLY} ${DEFAULT}"
                # Next line continues current command
                PREFIX=">"
            else
                echo -e "${PREFIX} ${GREEN}${REPLY} ${DEFAULT}"
                # Next line is a new command
                PREFIX="\$"
            fi
        done
        echo -e "${YELLOW}Press [ENTER] to run${DEFAULT}"
        read KEY
        . ${COMMAND}
        echo
        echo -e "${YELLOW}Press [ENTER] to continue${DEFAULT}"
        read KEY
        if [[ "$?" != 0 ]]; then
            echo
            echo -e "${RED}Command failed stopping demo${DEFAULT}"
            break
        fi
    done
    echo
}

prepare() {
    if [[ -f prepare.sh ]]; then
        echo
        echo -e "${YELLOW}### Preparing demo${DEFAULT}"
        bash prepare.sh
    fi
}

clean() {
    docker ps -aq | xargs -r docker rm -f >/dev/null
    docker system prune --all --volumes --force >/dev/null

    if [[ -f clean.sh ]]; then
        bash clean.sh
    fi
}

split() {
    if [[ "$#" == "0" ]]; then
        echo "Usage: $0 <demo_name>"
        return
    fi
    DEMO=${1}

    cat ${DEMO}.demo | tail -n +2 | grep -vE '^\s*$' | csplit --prefix ${DEMO}- --suffix-format '%01d.command' --elide-empty-files --quiet - '/^#/' {*}
}

include() {
    FILE=${1}
    if [[ -z "${FILE}" ]]; then
        echo "Usage: $0 <basename>"
        return
    fi
    PATTERN="^\s*<!--\s*include\:\s*(.+\.command)\s*-->\s*$"
    cat ${FILE}.template.md | while read; do
		if [[ ${REPLY} =~ ${PATTERN} ]]; then
			FILE=$(echo ${REPLY} | sed -E "s/${PATTERN}/\1/")
            TEXT=$(cat ${FILE} | grep -E "^#" | head -n 1 | sed -E 's/^#\s*(.+)$/\1/')
            echo "${TEXT}:"
            echo
            echo '```plaintext'
            cat ${FILE} | grep -vE "^\s*$" | grep -vE "^#"
            echo '```'
        else
            echo "${REPLY}"
		fi
	done >${FILE}.final.md
}
