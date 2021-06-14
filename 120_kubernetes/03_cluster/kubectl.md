## kubectl

CLI for Kubernetes API

XXX

XXX links

Installation

```bash
curl -L -s https://dl.k8s.io/release/stable.txt | \
    xargs -I{} \
        curl https://dl.k8s.io/release/{}/bin/linux/amd64/kubectl \
            --silent \
            --location \
            --output /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
```
