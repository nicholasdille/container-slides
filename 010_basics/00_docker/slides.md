## Names

### The Good

Docker is a company

`docker` is a container management tool

### The Bad

Containerize not dockerize

### The Ugly

I have an application in a docker

--

## What is so spacial about Docker

### In the beginning there were logical partitions (LPARs)

Made by our parents

### Then came Linux Containers (LXC)

Made by our brothers and sisters

Interface to cgroups and namespaces in the kernel

### The rise of Docker

Founded 2013 by Solomon Hykes

He revolutionized container management

--

## Concepts

### Process Isolation

Processes cannot see the host OS

Processes cannot see into other containers

### Kernel is responsible

Isolation

Resource management

### Containers are immutable

Configuration changes only when created

--

## Containers vs. VMs

### Different levels of virtualization

Hardware virtualization isolated operating systems

Containers isolate processes

XXX illustration

### Containers are just another option!

--

## Advantages

![DevOps infinite loop](../images/DevOps.png)

### Development

Reproducible environment

Packaged runtime environment

Deployable for testing

### Operations

Lightweight virtualization

Density

Dependency management

--

## Nomenclature

### Container

Isolated process

Runtime environment

### Image

Base image to create identical containers from

Immutable

### Registry

Plce to store images

--

## Container

![Container](images/Container.png) <!-- .element: style="float: right; width: 50%;" -->

### Isolated processes

### Shared, read-only image

### Dedicated, writable volume

### Network

--

## Why Containers

<div style="width: 32%; padding-right: 2%; float: left; text-align: center">
<p><i class="fas fa-umbrella fa-2x"></i></p>

<h3>Isolated</h3> <!-- .element: style="font-size: 0.8em;" -->

<p>Process isolation</p>
<p>Resource management</p>
</div>

<div style="width: 32%; padding-right: 2%; float: left; text-align: center">
<p><i class="fas fa-suitcase fa-2x"></i></p>

<h3>Packaged</h3>

<p>Runtime environment</p>
<p>Distributable package</p>
</div>

<div style="width: 32%; float: right; text-align: center">
<p><i class="fas fa-cog fa-2x"></i></p>

<h3>Automated</h3>

<p>Reproducible tasks</p>
<p>Fast deployments</p>
</div>

---

## Internals

### Namespaces

* Used for resource isolation
* Isolation of resource usage to limit visibility
* Types are PID, network, mount

### c(ontrol)groups

* Used to limit resource usage for proceses
* Limits and measures access to...
* ...CPU, memory, network, IO

---

## Docker

### Packaged

* Includes dependencies
* Distributable

### Immutable

* Incremental changes not supported
* Changes require rollout

### Automated

* Image builds
* Deployments

### Stateless

* By default, no persistence

--

## Containers

Process Isolation

Dedicated resources

Resource reservation / limitation

But... it's just a process <!-- .element: style="color: #ff8800;" -->
