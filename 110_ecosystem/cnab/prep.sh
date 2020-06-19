#!/bin/bash

# duffle
curl --silent https://api.github.com/repos/cnabio/duffle/releases/latest | \
    jq --raw-output '.assets[] | select(.name == "duffle-linux-amd64") | .browser_download_url' | \
    xargs curl --silent --location --fail --output /usr/local/bin/duffle
chmod +x /usr/local/bin/duffle

# porter
curl https://cdn.porter.sh/latest/install-linux.sh | bash

# cnab-to-oci
docker build --tag cnab2oci:v0.3.0-beta1 --target build --build-arg BUILDTIME=$(date +%Y%m%d%H%M) --build-arg TAG=v0.3.0-beta1 github.com/docker/cnab-to-oci#v0.3.0-beta1
docker ps --filter name=cnab2oci -aq | xargs -r docker rm
docker create --name cnab2oci cnab2oci:v0.3.0-beta1
rm -f /usr/local/bin/cnab-to-oci
docker cp cnab2oci:/go/src/github.com/docker/cnab-to-oci/bin/cnab-to-oci /usr/local/bin/cnab-to-oci
docker ps --filter name=cnab2oci -aq | xargs -r docker rm
