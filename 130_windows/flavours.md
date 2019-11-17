## Windows Containers

Introduced in Windows 10 and Windows Server 2016

Managed by Docker <i class="fab fa-docker"></i>

Two flavours:

![Windows containers and Hyper-V containers](media/ContainerFlavours.svg) <!-- .element: style="background: none; box-shadow: none; float: left;" -->

---

## Base images

`microsoft/nanoserver`

- Minimal base image
- Limited API Support, no PowerShell

`microsoft/windowsservercore`

- Equivalent to Windows Server Core

`microsoft/windows`

- Just announced at //build
- Bridging the gap to installed Windows

---

## LTSC and SAC

Windows Server 2016 is already lagging behind

Windows Server 1709

- Offers smaller base images
- Additional features

Windows Server 1803-preview

- Smallest base images yet

**Stability comes at a price!**