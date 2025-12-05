## Namespaces

Primary isolation feature used for containers

Processes can be isolated in the following namespaces:

- `pid` for process IDs
- `mnt` for mountpoints
- `uts` for hostname (Unix Timesharing Systems)
- `ipc` for inter-process communication
- `net` for networking

Containers isolate all namespaces by default

Can be nested

---

## Demo: Namespaces <!-- directory -->

- Show namespaces created by Docker
- Enter existing namespaces
- Create custom namespaces

See `namespaces.demo`

(Very extensive and does not fit on a slide.)

---

## Demo: Sharing namespaces <!-- directory -->

The nginx container image does not contain `ps`

<!-- include: namespaces-12.command -->

<!-- include: namespaces-13.command -->

<!-- include: namespaces-14.command -->

The same works for other namespaces

---

## Further reading

https://www.nginx.com/blog/what-are-namespaces-cgroups-how-do-they-work/

https://www.redhat.com/sysadmin/building-container-namespaces

https://www.redhat.com/sysadmin/pid-namespace

https://www.redhat.com/sysadmin/mount-namespaces

https://www.redhat.com/sysadmin/container-namespaces-nsenter
