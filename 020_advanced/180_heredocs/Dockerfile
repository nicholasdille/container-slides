# syntax=docker/dockerfile:1.3-labs

ARG VERSION=21.04
FROM ubuntu:${VERSION}

RUN <<EOF
ps faux
EOF

RUN bash -xe <<EOF
echo foo
EOF

RUN python3 <<EOF
print("bar")
EOF

RUN <<EOF
#!/bin/bash
ps faux
EOF

COPY --chmod=0755 <<EOF /entrypoint.sh
#!/bin/bash
exec "$@"
EOF

COPY <<no-recommends <<no-suggests /etc/apt/apt.conf.d/
APT::Install-Recommends "false";
no-recommends
APT::Install-Suggests "false";
no-suggests

RUN <<EOF
apt-get update
apt-get -y install \
    python3
EOF
