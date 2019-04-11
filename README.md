# Bistrotime Kubernetes

Kubernetes bootstrap configuration for a new cluster.

## Google Cloud Platform

```bash
$ gcloud container clusters get-credentials bistrotime
```

## Helm

```bash
$ kubectl apply -f helm.yaml
$ helm init --service-account tiller --history-max 100
```

## NGINX ingress controller

```bash
$ helm install stable/nginx-ingress --name nginx-ingress --namespace nginx-ingress --set rbac.create=true
```

## Cert manager

```bash
$ kubectl apply -f cert-manager.yaml
$ kubectl create namespace cert-manager
$ kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
$ helm repo add jetstack https://charts.jetstack.io
$ helm repo update
$ helm install --name cert-manager --namespace cert-manager --version v0.7.0 jetstack/cert-manager
```