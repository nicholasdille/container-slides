<i class="fa fa-solid fa-poo-storm fa-8x"></i> <!-- .element: style="float: right;" -->

## Error Handling

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### Errors must be handled

```bash
# do not suppress errors
test -f missing_file_name || true
```

### `errexit` is not enough

```bash
# Enable errexit (short version)
set -e

# Enable errexit (long version)
set -o errexit
```

### Use `if` for error handling

```bash
if test -f missing_file_name; then #...

if grep --quiet pattern file; then #...
```

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### Know your tools

`curl` signals success if the call completed:

```bash
if curl http://example.com; then
    echo "Succeeded for any HTTP response"
fi
```

Tell `curl` to `--fail` on HTTP errors (>= 400):

```bash
if curl --fail http://example.com; then
    echo "Succeeded only for HTTP 2xx/3xx"
fi
```

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### Fail on missing variables

```bash
set -o nounset

# This fails
echo $foo
```

### Pipes mask errors

Enable `pipefail` to catch errors in pipes:

```bash
set -o errexit
set -o pipefail

false | cat
echo "This is NOT executed"
```

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Errors caused by error handling

### Early Pipe Closure

Pipes can close early

`head -n 1` closes stdin after the first line...

...and `sort` writes to a close pipe causing `SIGPIPE`

```bash
# fails with SIGPIPE
cat data.txt | sort | head -n 1

# works
cat data.txt | sort -r | tail -n 1

# workaround
cat data.txyt | sort | (head -n 1; cat >/dev/null)
```

Cause of flaky tests