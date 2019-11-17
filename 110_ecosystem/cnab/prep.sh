#!/bin/bash

# duffle
curl -sLfo /usr/local/bin/duffle https://github.com/deislabs/duffle/releases/download/0.3.5-beta.1/duffle-linux-amd64
chmod +x /usr/local/bin/duffle

# porter
curl -sLfo /usr/local/bin/porter https://deislabs.blob.core.windows.net/porter/v0.20.2-beta.1/porter-linux-amd64
chmod +x /usr/local/bin/porter
cp /usr/local/bin/porter /usr/local/bin/porter-runtime
for MIXIN in exec kubernetes helm azure terraform az aws gcloud; do
    porter mixin install ${MIXIN} --version latest
done

# cnab-to-oci
docker build --tag cnab2oci:v0.3.0-beta1 --target build --build-arg BUILDTIME=$(date +%Y%m%d%H%M) --build-arg TAG=v0.3.0-beta1 github.com/docker/cnab-to-oci#v0.3.0-beta1
docker ps --filter name=cnab2oci -aq | xargs -r docker rm
docker create --name cnab2oci cnab2oci:v0.3.0-beta1
rm -f /usr/local/bin/cnab-to-oci
docker cp cnab2oci:/go/src/github.com/docker/cnab-to-oci/bin/cnab-to-oci /usr/local/bin/cnab-to-oci
docker ps --filter name=cnab2oci -aq | xargs -r docker rm
