## Playground Docker Host

XXX

```bash
iptables -A INPUT -i eth0 -p tcp –dport 22 -j ACCEPT
iptables -A INPUT ! -i eth0 -j ACCEPT
iptables -A INPUT -j DROP
```

XXX reset

```bash
docker system prune
```