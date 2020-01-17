#!/bin/bash

. functions.sh

echo
echo -e "${YELLOW}Waiting for demo to end. Press enter to continue...${DEFAULT}"
read

hcloud server list -l demo=true -o columns=name | tail -n +2 | while read NAME; do
    hcloud server delete ${NAME}
done

hcloud ssh-key delete demo
rm id_rsa_demo*
rm ~/id_rsa_demo
