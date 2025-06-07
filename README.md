# Hybrid Kubernetes GitOps Platform (Minikube + AKS)

## Overview

This project demonstrates a **hybrid Kubernetes platform** integrating an on-premises Minikube cluster with a production-grade Azure Kubernetes Service (AKS) cluster. It uses **GitOps via ArgoCD**, **Helm for app deployment**, and a **complete observability stack** built with Prometheus, Grafana, and Fluent Bit.

This setup is modeled after real-world CI/CD environments used by DevOps teams to manage multi-cluster Kubernetes infrastructure with a consistent Git-based deployment pipeline.

---

## Key Features

| Feature | Description |
|--------|-------------|
| Hybrid Kubernetes | Combines Minikube (local/on-prem) and Azure AKS |
| GitOps | Declarative app deployments with ArgoCD |
| Helm | Helm charts manage microservice lifecycle |
| Observability | Prometheus, Grafana, and Fluent Bit integration |
| Azure Integration | Infra provisioned using Terraform for AKS |
| Security | Proper RBAC, namespaces, and monitoring isolation |

---

## Folder Structure

hybrid-k8s-gitops-platform/
├── terraform/ # AKS provisioning
├── helm/ # Helm charts (app + monitoring)
├── argo-apps/ # ArgoCD application manifests
├── observability/ # Grafana dashboards, configs
├── scripts/ # Setup scripts (init, secrets, etc.)
├── README.md

---

## Prerequisites

- [ ] Azure account with CLI access
- [ ] Minikube / local cluster for testing
- [ ] kubectl & Helm installed
- [ ] ArgoCD CLI (optional)
- [ ] Terraform CLI
- [ ] GitHub (for GitOps repo)

---

## Usage Guide

### Step 1: Provision Azure AKS (Terraform)

```
cd terraform
terraform init
terraform apply
```

Outputs:
- AKS cluster
- Kubeconfig for authentication

To configure kube access:
```
az aks get-credentials --resource-group aks-hybrid-rg --name aks-hybrid-cluster
```

### Step 2: Install ArgoCD (Minikube or AKS)

```
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
Access ArgoCD:
```
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Step 3: Configure GitOps Apps
```
kubectl apply -f argo-apps/ --namespace argocd
```
Apps auto-sync from this Git repo using ArgoCD.

#### Note: Alternatively, Skip steps 2 and 3, hen run scripts/init-cluster.sh to install ArgoCD + deploy apps.

### Step 4: Install Observability Stack
```
cd helm/monitoring
helm install monitoring . -n monitoring --create-namespace
```

This installs:
- Prometheus
- Grafana
- Fluent Bit for log collection

### Step 5: Deploy Sample App to Both Clusters
```
cd helm/app
helm install myapp . -n dev --create-namespace
```
---

## Security & RBAC
- ArgoCD restricted to argocd namespace
- App and monitoring in isolated namespaces
- Secrets handled via sealed-secrets or SOPS (optional enhancement)

---

## Roadmap
- Add SOPS/Sealed Secrets for secret management
- Add NGINX ingress + TLS cert-manager
- Add Slack webhook alerts via Prometheus Alertmanager
- Add Jenkins or GitHub Actions integration for build pipelines

---
