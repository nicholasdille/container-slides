## Why a container orchestrator

Containers are easy on a single host

Production environments require high availability

HA requires multiple hosts

### Container orchestrator

Responsible for containers on multiple hosts

### Offerings

Kubernetes

Docker Swarm

---

## Tasks of a container orchestrator

<div style="display: grid; grid-template-columns: 1fr 1fr; grid-gap: 1em; text-align: left; font-size: larger;">

<div>

### Rollout

Distribute services across hosts

Balance resource usage

### Scale

Maintain copies of a service definition

Add and remove copies of services

### Recovery

Restart misbehaving services

Compensate for outages

</div>
<div>

### Update

Replace services with an updated version

Ensure availability

### Cleanup

Remove services...

...including all copies

</div>

</div>

---

## That's why

Container orchestrators make your life easier

Use multiple hosts for high availability

Compensate for outages and errors

Ops has time for more important tasks

Kubernetes is most widely used
