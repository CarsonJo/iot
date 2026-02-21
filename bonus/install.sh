curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4
chmod 700 get_helm.sh
./get_helm.sh

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm search repo gitlab

kubectl create namespace gitlab 

helm install gitlab gitlab/gitlab --namespace gitlab --create-namespace --set certmanager-issuer.email=carson7741@gmail.com \
		--set global.hosts.domain=127.0.0.1.nip.io \
		--set global.hosts.https=false \
		--set nginx-ingress.enabled=false \
		--set global.ingress.enabled=false \
		--set global.ingress.configureCertmanager=false


#kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo

#kubectl exec -n gitlab \
#  $(kubectl get pod -n gitlab -l app=webservice -o jsonpath='{.items[0].metadata.name}') \
#  -c webservice \
#  -- grep -A5 "host:" /srv/gitlab/config/gitlab.yml | head -30
