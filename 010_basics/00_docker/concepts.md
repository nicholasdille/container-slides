## Container concepts
<!-- .slide: id="concepts" -->

### Process Isolation

Processes cannot see the host OS

Processes cannot see into other containers

### Kernel is responsible

Isolation

Resource management

### Containers are immutable

Configuration changes require recreation

--

## Containers versus virtual machines

### Different levels of virtualization

Virtual machines isolate operating systems

Containers isolate processes

![Hardware virtualization vs. containers](010_basics/00_docker/containers_vs_vms.drawio.svg)

### Containers are just another option!

--

## Advantages

![DevOps infinite loop](../images/DevOps.png)
<!-- .element: style="width: 50%; float: right;" -->

### Development

Reproducible environment

Packaged runtime environment

Deployable for testing

### Operations

Lightweight isolation

Density

Dependency management

---

## Nomenclature

### Container

Isolated process(es)

Runtime environment

### Image

Root FS to create containers from

Immutable

### Registry

Place to store images

--

## Container

![Container](010_basics/00_docker/container.drawio.svg) <!-- .element: style="float: right; width: 40%; padding-right: 2em;" -->

### Isolated processes

### Shared, read-only image

### Dedicated, writable volume

### Network

--

## Why Containers

<div style="width: 32%; padding-right: 0.5em; float: left; text-align: center;">
<p><i class="fas fa-umbrella fa-3x"></i></p>

<h3>Isolated</h3>

<p>Process isolation</p>
<p>Resource management</p>
</div>

<div style="width: 32%; padding-right: 0.5em; float: left; text-align: center;">
<p><i class="fas fa-suitcase fa-3x"></i></p>

<h3>Packaged</h3>

<p>Runtime environment</p>
<p>Distributable package</p>
</div>

<div style="width: 32%; float: right; text-align: center;">
<p><i class="fas fa-cog fa-3x"></i></p>

<h3>Automated</h3>

<p>Reproducible tasks</p>
<p>Fast deployments</p>
</div>
