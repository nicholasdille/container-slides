## Error Handling

<i class="fa-duotone fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

set -o errexit

set -o nounset (?)

set -o pipefail (?)

CMD || true

if CMD; then

curl --fail