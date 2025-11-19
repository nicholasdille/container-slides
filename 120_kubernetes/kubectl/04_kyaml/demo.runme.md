# KYAML

Test KYAML.

## Preparation

Enable KYAML (experimental):

```bash
export KUBECTL_KYAML=true
```

## Demo

Show resource in KYAML instead of YAML:

```bash
kubectl get deployment simple -o kyaml
```

## Cleanup

Remove deployment:

```bash
kubectl delete -f deployment.yaml
```
