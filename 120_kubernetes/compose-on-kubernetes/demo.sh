#!/bin/bash

## ********************************** ####
## Creating Compose Namespace
## ********************************** ####

echo "Creating Compose Namespace..."
kubectl create namespace compose

## Pulling Helm Installable


echo "Installing Helm..."
curl https://storage.googleapis.com/kubernetes-helm/helm-v2.12.1-linux-amd64.tar.gz -o helm-v2.12.1-linux-amd64.tar.gz
## Unzip Helm

echo "Preparing Helm"
tar xvf helm-v2.12.1-linux-amd64.tar.gz

## Adding Helm to PATH 


## export PATH=$PATH:/root/linux-amd64
cp -rf linux-amd64/* /usr/local/bin/

echo "Creating tiller under kube-system namespace..."

kubectl -n kube-system create serviceaccount tiller


kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller --upgrade
# wait until helm list works
sleep 15

echo " Tiller is still coming up...Please Wait"
kubectl -n kube-system get po

sleep 10

helm list
helm install --name etcd-operator stable/etcd-operator --namespace compose


## Installing wget

yum install -y wget

helm init --service-account tiller --upgrade
kubectl apply -f - << EOF
 apiVersion: "etcd.database.coreos.com/v1beta2"
 kind: "EtcdCluster"
 metadata:
   name: "compose-etcd"
   namespace: "compose"
 spec:
   size: 3
   version: "3.2.13"
EOF
sleep 10
kubectl -n kube-system get po
## Download the Compose installer

wget https://github.com/docker/compose-on-kubernetes/releases/download/v0.4.18/installer-linux
chmod +x installer-linux
./installer-linux -namespace=compose -etcd-servers=http://compose-etcd-client:2379 -tag=v0.4.18 

## Verifying 

kubectl api-versions | grep compose

## Building up App Stack

docker stack deploy --orchestrator=kubernetes -c docker-compose.yml hellostack

## Getting the Stack

kubectl get stacks
