## Portability

<i class="fa-duotone fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

### Follow POSIX `sh`

```bash
# Only bash
[ -z "$var" ] && echo "empty"

# Portable
test -z "$var" && echo "empty"
```

See [pure sh bible](https://github.com/dylanaraps/pure-sh-bible)

---

## Portability

<i class="fa-duotone fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

### different distributions

XXX package managers

XXX file locations

---

## Portability

<i class="fa-duotone fa-solid fa-cart-flatbed-suitcase fa-4x"></i> <!-- .element: style="float: right;" -->

### `busybox` is too small

```bash
# Works on traditional distribution
# Breaks on busybox
cat file | grep --quiet "pattern"

# Works on both
cat file | grep -q "pattern"
```