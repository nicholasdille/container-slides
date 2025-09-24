```bash
#!/bin/bash
set -o errexit

curl -sf http://example.com && echo yes || echo no

cat /var/log/syslog | grep -i error | xargs ..

1
2
3
4
```
<!-- .element: style="width: 30em; float: right;" -->

## Shell Code

Whatever you execute on the console...

...put in a file

---

## Advantages

<i class="fa-duotone fa-solid fa-thumbs-up fa-4x"></i> <!-- .element: style="float: right;" -->

Always available

No libraries

Command line tools

---

## Disadvantages

<i class="fa-duotone fa-solid fa-thumbs-down fa-4x"></i> <!-- .element: style="float: right;" -->

Readability

Portability

Performance