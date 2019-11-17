## cgroups

Located in `/sys/fs/cgroups/`

Tools: `apt-get install cgroup-tools`

`cgcreate`

https://www.linuxjournal.com/content/everything-you-need-know-about-linux-containers-part-i-linux-control-groups-and-process

--

## Namespaces

types:

- process
- network
- mount
- user

tools:

- `lsns`
- `nsenter`
- `ip netns`
