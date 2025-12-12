sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update
yes | sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

#install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
k3d cluster create my-cluster --api-port 6443 -p "8080:80@loadbalancer"

#install kubectl
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
#install argocd
sudo kubectl create namespace argocd
sudo kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sudo kubectl create namespace dev
#adding us to docker group so that we can run k3d command
sudo usermod -aG docker vagrant

#add ssh key to authorizedkey
cat /home/vagrant/.ssh/my_key.pub >> /home/vagrant/.ssh/authorized_keys
#instaling argocd cli
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64
#kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d //get password to connect on browser
#kubectl port-forward svc/argocd-server -n argocd 8080:443 //port-forward to access from browser
#argocd login localhost:8080 //login to argocd
#argocd app create will-app \
#  --repo https://github.com/CarsonJo/cjozefzo-iot \
#  --path . \
#  --dest-server https://kubernetes.default.svc \
#  --dest-namespace dev // create app
# argocd app sync wil-playground //sync app
# argocd app set will-app --sync-policy automated // automatique sync
