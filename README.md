# Inception-of-Things (IoT)

> A 42 School DevOps project — an introduction to Kubernetes using K3s, K3d, Vagrant, and Argo CD.

---

## About

This project is a minimal introduction to **Kubernetes** from a developer perspective. It covers setting up lightweight Kubernetes clusters, managing containerised applications, configuring ingress routing, and implementing continuous integration with GitOps via **Argo CD**.

The entire project runs inside virtual machines provisioned with **Vagrant**.

---

## Project Structure

```
.
├── p1/       # K3s cluster with Vagrant (server + agent)
├── p2/       # K3s with Ingress — three web apps routing
├── p3/       # K3d + Argo CD continuous deployment
```

---

## Parts

### Part 1 — K3s and Vagrant

Sets up **two virtual machines** with Vagrant:

| Machine        | Role       | K3s Mode   |
|----------------|------------|------------|
| `Server`       | Controller | `server`   |
| `ServerWorker` | Agent      | `agent`    |

Both machines are provisioned automatically with shell scripts. The agent joins the server via a shared token.

### Part 2 — K3s and Three Simple Applications

Deploys **three web applications** inside a single K3s VM using a **Kubernetes Ingress** to route traffic based on the `HOST` header:

| Host       | Application |
|------------|-------------|
| `app1.com` | App 1       |
| `app2.com` | App 2       |
| *(default)*| App 3       |

All apps are accessible at `192.168.42.110` and routing is handled entirely by the Ingress controller.

### Part 3 — K3d and Argo CD

Sets up a **K3d** cluster (Kubernetes in Docker) with two namespaces:

- `argocd` — runs the Argo CD instance
- `dev` — hosts the deployed application

Argo CD watches a GitHub repository and **automatically syncs** any changes, enabling a full GitOps continuous deployment pipeline. The app deployed is [`wil42/playground`](https://hub.docker.com/r/wil42/playground) (port `8888`), and two versions are managed through the pipeline.


## Requirements

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/) (or another Vagrant provider)
- [Docker](https://www.docker.com/) (for Part 3 / K3d)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

---

## Usage

### Part 1

```bash
cd p1
vagrant up
```

### Part 2

```bash
cd p2
vagrant up
```

Then visit `http://192.168.42.110` in your browser with the appropriate `HOST` header, or use:
it will not work on all machine because we were working in a vm made with virtualbox with an host only adaptator network to access the vagrant vm from the host.
you should change in the vagrant file:
```vm.vm.network "public_network",bridge: "enp0s8", ip:"192.168.56.110" -> vm.vm.network "private_network", ip:"192.168.56.110"```

```bash
curl -H "Host: app1.com" http://192.168.42.110
```

### Part 3

```bash
cd p3
./scripts/install.sh
kubectl apply -f ./conf/ingress.yaml
./scripts/app.sh
```

Access the Argo CD UI and watch the app auto-deploy from your repository.

---

## Key Technologies

| Tool                  | Purpose                                      |
|-----------------------|----------------------------------------------|
| Vagrant               | VM provisioning and management               |
| K3s                   | Lightweight Kubernetes for VMs               |
| K3d                   | Kubernetes in Docker (K3s inside containers) |
| Argo CD               | GitOps continuous deployment                 |
| Kubernetes Ingress    | Host-based HTTP routing                      |
| Gitlab                | Self-hosted git + CI/CD (bonus)              |

---

## Author

**CarsonJo** — [github.com/CarsonJo](https://github.com/CarsonJo)
