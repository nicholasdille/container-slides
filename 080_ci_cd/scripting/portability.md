<i class="fa-duotone fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### Follow POSIX `sh`

```bash
# Only bash
[[ $var =~ /^foo\s/ ]] && echo "starts with foo"

# Portable
test -z "$var" && echo "empty"
[ -z "$var" ] && echo "empty"
grep --extended-regexp --quiet '^foo\s' <<< "$var" && echo "starts with foo"
```

Rule of thumb: If it makes your life easier, it will not be portalble <i class="fa-duotone fa-face-rolling-eyes"></i>

---

<i class="fa-duotone fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

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

Workarounds found in [pure sh bible](https://github.com/dylanaraps/pure-sh-bible) - increases complexity

---

<i class="fa-duotone fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### Distributions 1/2

Obviously different package managers

Also different package names:

```bash
apt-get install foo
apk add bar
yum install baz
```

---

<i class="fa-duotone fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### Distributions 2/2

In addition, different file locations:

```bash
XXX
YYY
```

---

<i class="fa-duotone fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### `busybox` is too small

Long parameter are missing:

```bash
# Works on traditional distribution
# Breaks on busybox
cat file | grep --quiet "pattern"

# Works on both
cat file | grep -q "pattern"
```

Sacrifices readability