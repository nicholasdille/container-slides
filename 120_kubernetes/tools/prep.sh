#!/bin/bash

curl -sLfo /usr/local/bin/kubectx https://github.com/ahmetb/kubectx/raw/v0.7.0/kubectx
curl -sLfo /usr/local/bin/kubens https://github.com/ahmetb/kubectx/raw/v0.7.0/kubens
chmod +x /usr/local/bin/{kubectx,kubens}

curl -sLf https://github.com/robscott/kube-capacity/releases/download/0.3.2/kube-capacity_0.3.2_Linux_x86_64.tar.gz | tar -xvz -C /usr/local/bin/ kube-capacity