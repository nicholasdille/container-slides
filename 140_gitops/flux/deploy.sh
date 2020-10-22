# Create namespace
kubectl create ns flux

# Install flux
GHUSER="nicholasdille"
fluxctl install \
--git-user=${GHUSER} \
--git-email=${GHUSER}@users.noreply.github.com \
--git-url=https://github.com/nicholasdille/k8s-gitops \
--git-branch=master \
--git-path=app/traefik \
--git-readonly \
--manifest-generation \
--registry-disable-scanning \
--namespace=flux | kubectl apply -f -