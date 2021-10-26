# syntax=docker/dockerfile:1.3-labs

ARG VERSION=21.04
FROM ubuntu:${VERSION}

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

RUN <<EOF
ps faux
EOF

RUN bash -xe <<EOF
echo foo
EOF

RUN <<EOF
#!/bin/bash
ps faux
EOF

RUN python3 <<EOF
print("bar")
EOF