## Runtimes

![](120_kubernetes/gvisor/runtime.drawio.svg) <!-- .element: style="float: right; width: 15%;" -->

OCI runtimes are responsible for interactive with the kernel

They implement the OCI runtime spec

They are pluggable

### Implementations

Reference implementation by OCI (Go): runc [](https://github.com/opencontainers/runc)

Lightweight implementation by RedHat (C): crun [](https://github.com/containers/crun)

Application kernel by Google (Go): gvisor [](https://github.com/google/gvisor)

Lightweight VMs using QEMU/KVM (Go): kata-containers [](https://github.com/kata-containers/kata-containers)

Micro VMs by AWS (Rust): Firecracker [](https://github.com/firecracker-microvm/firecracker)

---

## gvisor

Application kernel that...

"implements a substantial portion of the Linux system call interface"

### Binaries

Ships with...

- an OCI runtime `runsc`
- a containerd shim `containerd-shim-runsc-v1`

### Security model

XXX https://gvisor.dev/docs/architecture_guide/security/

---

## Concepts

![](120_kubernetes/gvisor/concepts.drawio.svg) <!-- .element: style="float: right; width: 65%;" -->

Comparison to...

Hardware virtualization

Syscall filtering using seccomp, SELinux and AppArmor

### Sentry

Application kernel

Intercepts system calls

Starts in container w/ seccomp

### Gofer

Host process for every container

Talks to Sentry using 9P

---

## Demo

gvisor in Kubernetes