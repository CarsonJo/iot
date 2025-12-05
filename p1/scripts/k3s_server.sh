#!/bin/bash

curl -sfL https://get.k3s.io | sh -s - --node-ip 192.168.56.110
chmod 755 /etc/rancher/k3s/k3s.yaml
TOKEN=$(sudo cat /var/lib/rancher/k3s/server/node-token)
echo $TOKEN > /vagrant/token
