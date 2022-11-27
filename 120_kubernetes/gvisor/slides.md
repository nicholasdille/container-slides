## Runtimes

XXX runc, crun

XXX gvisor

XXX kata containers with qemu/kvm (or firecracker)

XXX containerd with firecracker

---

## gvisor

XXX application kernel

XXX "implements a substantial portion of the Linux system call interface"

XXX https://gvisor.dev/

XXX https://gvisor.dev/docs/user_guide/install/#specific-release

XXX https://gvisor.dev/docs/architecture_guide/security/

---

## Concepts

![](120_kubernetes/gvisor/concepts.drawio.svg)

XXX sentry: application kernel, intercepts system calls, started in restrited seccomp container without filesystem access

XXX gofer: host process for every container, talks to sentry using 9P protocol

---

## Demo

XXX https://github.com/gnmahanth/kind-runsc

XXX https://kubernetes.io/docs/concepts/containers/runtime-class/