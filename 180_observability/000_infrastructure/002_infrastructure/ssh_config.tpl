Host ${node}
    HostName ${node_ip}
    User root
    IdentityFile ${ssh_key_file}
    StrictHostKeyChecking no
    UserKnownHostsFile /dev/null