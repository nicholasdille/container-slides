<i class="fa fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### Follow POSIX `sh`

Least common denominator

```bash
# Only bash
[[ $var =~ /^foo\s/ ]] && echo "starts with foo"

# Portable
test -z "$var" && echo "empty"
[ -z "$var" ] && echo "empty"
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

Workarounds found in [pure sh bible](https://github.com/dylanaraps/pure-sh-bible) - increases complexity

Also: Security issues from outdated tools

---

<i class="fa fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### Distributions 1/2

Obviously different package managers

Also different package names:

```bash
# Ubuntu
apt-get install libz1g

# Alpine Linux
apk add libz

# Fedora
yum install zlib-ng
```

---

<i class="fa fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

## Portability

### Distributions 2/2

In addition, different file locations

For example, network configuration files:

| Distribution | Tool               | Location            | Format |
|--------------|--------------------|---------------------|--------|
| Ubuntu       | netplan            | /etc/netplan/       | YAML   |
| Fedora       | NetworkManager     | /etc/NetworkManager/| TOML   |
| Alpine Linux | ifupdown (busybox) | /etc/network/       | Text   |

<!-- .element: style="font-size: smaller;" -->

---

<i class="fa fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

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

Size sacrifices readability <i class="fa fa-face-rolling-eyes"></i>