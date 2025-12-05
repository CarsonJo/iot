#!/bin/bash

SERVER_IP=$1

TOKEN=$(cat /vagrant/token)

curl -sfL https://get.k3s.io | K3S_URL=https://$SERVER_IP:6443 K3S_TOKEN=$TOKEN sh -s - --node-ip 192.168.56.111
