id_rsa:
	@jq --raw-output '.outputs.ssh_private_key.value' ../002_hcloud/state.json >$@

ips.txt:
	@jq --raw-output '.outputs.ipv4_addresses.value[]' ../002_hcloud/state.json >$@
