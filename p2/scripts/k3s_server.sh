#!/bin/bash

HOME=/home/vagrant
curl -sfL https://get.k3s.io | sh -s - --node-ip 192.168.56.110
chmod 755 /etc/rancher/k3s/k3s.yaml
kubectl apply -f $HOME/app1
kubectl apply -f $HOME/app2
kubectl apply -f $HOME/app3
kubectl apply -f $HOME/ingress.yaml
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo $TOKEN > /vagrant/token
