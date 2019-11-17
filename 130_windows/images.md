## Custom Images

Simple scripting language:

```dockerfile
FROM microsoft/windowsservercore:1709

SHELL [ "powershell", "-command" ]

RUN Add-WindowsFeature -Name Hyper-V-PowerShell

CMD [ "powershell" ]
```

Create image using:

```powershell
docker build --tag hypervps .
```

Run image:

```powershell
PS> docker run -it --rm hypervps
```