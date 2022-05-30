<!-- .slide: id="heredocs" class="center" style="text-align: center; vertical-align: middle" -->

## Heredocs

---

## Heredocs

```bash
$ cat <<EOF
line1
line2
EOF
line1
line2
```

[Supported](https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/syntax.md#here-documents) in `Dockerfile` with experimental syntax >= 1.3-labs

Fist line of `Dockerfile` must be:

```Dockerfile
# syntax=docker/dockerfile:1.4.2
```

---

## Demo: Heredocs <!-- directory -->

Use `RUN` like a script block

No more `&&` and `\`

```Dockerfile
RUN <<EOF
ps faux
EOF
```

<!-- include: heredocs-0.command -->

---

## Demo: Heredocs <!-- directory -->

Use a custom interpreter for the script block

```Dockerfile
RUN bash -xe <<EOF
echo foo
EOF
```

<!-- include: heredocs-1.command -->

---

## Demo: Heredocs <!-- directory -->

Provide shebang to set interpreter

```Dockerfile
RUN <<EOF
#!/bin/bash
ps faux
EOF
```

<!-- include: heredocs-2.command -->

---

## Demo: Heredocs <!-- directory -->

Provide inline file

```Dockerfile
COPY --chmod=0755 <<"EOF" /entrypoint.sh
#!/bin/bash
exec "$@"
EOF
```

<!-- include: heredocs-3.command -->

---

## Demo: Heredocs <!-- directory -->

Create multiple files in a single `COPY`

```Dockerfile
COPY <<no-recommends <<no-suggests /etc/apt/apt.conf.d/
APT::Install-Recommends "false";
no-recommends
APT::Install-Suggests "false";
no-suggests
```

<!-- include: heredocs-4.command -->
