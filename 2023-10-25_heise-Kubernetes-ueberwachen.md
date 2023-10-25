Prometheus, Pfeil krumm
MEtrics collection, Pfeil HPA -> metrics-server
Grafana datasource values.yaml
dashcoards

kube_pod_info * on(pod,namespace) group_right(node) kube_pod_labels * on(node) group_left(label_beta_kubernetes_io_instance_type) kube_node_labels

node_memory_Active_bytes * on(instance) group_left(nodename) node_uname_info

Prom recording rules