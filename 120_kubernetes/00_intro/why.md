## Why have a container orchestrator

Containers are easy on a single host

Production environments require high availability

HA requires multiple hosts

### Container orchestrator

Responsible for containers on multiple hosts

### Offering

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

</div>
<div>

### Update

Replace servoces with an updated version

Ensure availability

### Recovery

Restart misbehaving services

Compensate for outages

### Cleanup

Remove services...

...including all copies

</div>

</div>

---

## That's why (having a container orchestrator)

Container orchestrators make your life easier

Use multiple hosts for high availability

Compensate for outages and errors

Ops has time for more important tasks

Kubernetes is most widely used
