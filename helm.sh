#!/bin/bash

USER=helm
CA=ca.crt
KUBECONFIG_FILE=helm-kubeconfig

SECRET=$(kubectl get sa helm -o jsonpath='{.secrets[].name}' -n kube-system)
TOKEN=$(kubectl get secrets $SECRET -o jsonpath='{.data.token}' -n kube-system | base64 -D)

CONTEXT=$(kubectl config current-context)
CLUSTER_NAME=$(kubectl config get-contexts $CONTEXT --no-headers=true | awk '{print $3}')
SERVER=$(kubectl config view -o jsonpath="{.clusters[?(@.name == \"${CLUSTER_NAME}\")].cluster.server}")

kubectl get secrets $SECRET -o jsonpath='{.data.ca\.crt}' -n kube-system | base64 -D > $CA

kubectl config set-cluster $CLUSTER_NAME \
    --kubeconfig=$KUBECONFIG_FILE \
    --server=$SERVER \
    --certificate-authority=$CA \
    --embed-certs=true

kubectl config set-credentials \
    $USER \
    --kubeconfig=$KUBECONFIG_FILE \
    --token=$TOKEN

kubectl config set-context \
    $USER \
    --kubeconfig=$KUBECONFIG_FILE \
    --cluster=$CLUSTER_NAME \
    --user=$USER

kubectl config use-context \
    $USER \
    --kubeconfig=$KUBECONFIG_FILE

rm $CA

echo "Done, the configuration is stored inside ${KUBECONFIG_FILE}"
