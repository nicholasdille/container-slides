## Rootless Notes

Enable cgroup v2:

- In `/etc/default/grub` set `GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"`
- Run `update-grub` and `reboot`

[WSL2 and cgroup v2](https://github.com/microsoft/WSL/issues/6662): Requires change in Microsoft owned init for service VM

[usernetes](https://github.com/rootless-containers/usernetes): Run Kubernetes without root privileges

[sysbox](https://github.com/nestybox/sysbox): Next-generation "runc" that empowers rootless containers to run workloads such as Systemd, Docker, Kubernetes, just like VMs
