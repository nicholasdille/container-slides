# Demos

## Apply all files

In a directory:

```bash
kubectl apply -f ./dir/
```

With basic templating:

```bash
cat *.yaml | envsubst | kubectl apply -f -
```

## Waiting for consistency

XXX