<i class="fa fa-solid fa-cart-flatbed-suitcase fa-8x"></i> <!-- .element: style="float: right;" -->

## Portability

---

<i class="fa fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### Follow POSIX `sh`

Least common denominator

```bash
# Only bash
[[ $var =~ /^foo\s/ ]] && echo "starts with foo"

# Portable alternatives to [[...]]
test -z "$var" && echo "empty"
[ -z "$var" ] && echo "empty"

# Portable alternative to regular expressions
grep --extended-regexp --quiet '^foo\s' <<< "$var" && echo "starts with foo"
```

Rule of thumb: If it makes your life easier, it will not be portable <i class="fa fa-face-rolling-eyes"></i>

---

<i class="fa fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### Missing tools

Script must check availability of tools

```bash
func check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo "Error: $1 is not installed." >&2
        exit 1
    fi
}

check_tool curl
check_tool jq
```

---

<i class="fa fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### `busybox` is too small

Single binary implements all common Unix utilities

Long parameter are missing:

```bash
# Works on traditional distribution
# Breaks on busybox
cat file | grep --quiet "pattern"

# Works on busybox
cat file | grep -q "pattern"
```

Portability sacrifices size sacrifices readability <i class="fa fa-face-rolling-eyes"></i>