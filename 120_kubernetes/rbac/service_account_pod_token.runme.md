# Explore token mounted in a pod

https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#service-account-token-volume-projection

Check projected volume with token, CA and namespace

```sh
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: foo-test
spec:
  containers:
  - name: foo
    image: alpine
    command:
    - sh
    args:
    - -c
    - sleep 3600
EOF
sleep 5
kubectl get pod foo-test --output yaml
```