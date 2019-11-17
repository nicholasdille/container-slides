## k8s: Do not do bare-metal

### Bootstrapping is hard

- Use offerings in public clouds
- Otherwise, do not script yourself
- Use a project like [kubespray](https://github.com/kubernetes-sigs/kubespray)

### Mind the focus of KthW

- Focuses on installation of k8s
- But: Docker can interfere with iptables and break DinD
- But: Some CNI plugins do not configure `portmap` and break `hostPort`

### You build it, you own it

- Your responsibility
- Load balancing is much harder
- DMZ, firewalls and company policies are in your way
- Allocatable host resources and pod eviction are yours to configure
