## Control group (cgroups)

Kernel feature for resource management

Processes can have...

- limits
- reservations

Mostly used for CPU and memory

Exceeded memory limits result in out-of-memory (OOM) kills

Can be nested

Must be root to use cgroups v1

---

## Demo: Control groups (cgroups) <!-- directory -->

XXX v1 or v2

<!-- include: cgroups-0.command -->

<!-- include: cgroups-1.command -->

<!-- include: cgroups-2.command -->

XXX further reading

---

## Control groups v2

XXX

cat /sys/fs/cgroup/cgroup.controllers

sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"/' /etc/default/grub
update-grub
reboot
