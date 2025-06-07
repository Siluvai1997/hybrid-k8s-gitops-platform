#!/bin/bash

echo "[INFO] Creating namespaces..."
kubectl create ns argocd
kubectl create ns dev
kubectl create ns monitoring

echo "[INFO] Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "[INFO] Waiting for ArgoCD to be ready..."
kubectl rollout status deployment/argocd-server -n argocd --timeout=180s

echo "[INFO] Apply GitOps apps..."
kubectl apply -f ../argo-apps/ -n argocd

echo "[INFO] Setup complete. Access ArgoCD at port 8080."