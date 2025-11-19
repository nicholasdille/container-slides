<i class="fa fa-solid fa-poo-storm fa-8x"></i> <!-- .element: style="float: right;" -->

## Error Handling

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### `errexit` is not enough

Breaks when a command fails:

```bash
# Enable (short version)
set -e

# Enable (long version)
set -o errexit
```

Often you want to handle the error gracefully

Use `errexit` in addition to error handling

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### Errors should be handled

Do not suppress errors:

```bash
test -f missing_file_name || true
```

Be careful - this rarely makes sense!

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### Use `if` for error handling

Maps to `true` except when return code > 0:

```bash
if test -f missing_file_name; then
    echo "File exists"
else
    echo "File is missing"
fi
```

...also:

```bash
if grep --quiet pattern file; then
    echo "Pattern exists in file"
else
    echo "Pattern does not exist in file"
fi
```

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### Know your tools

`curl` signals success if it completed:

```bash
if curl http://example.com; then
    echo "Succeeded for any HTTP response"
fi
```

Tell `curl` to `--fail` on HTTP errors (>= 400):

```bash
if curl --fail http://example.com; then
    echo "Succeeded only for HTTP 2xx"
fi
```

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### Handle missing variables

Break on unset variables:

```bash
set -o nounset

# This fails
echo $foo
```

Exposes typos in variable names

---

<i class="fa fa-solid fa-poo-storm fa-4x"></i> <!-- .element: style="float: right;" -->

## Error Handling

### Pipes mask errors

`errexit` only catches the exit code of the last command:

```bash
set -o errexit

false | cat
echo "This is executed"
```

Use `set -o pipefail` to catch errors in pipelines

```bash
set -o errexit
set -o pipefail

false | cat
echo "This is NOT executed"
```