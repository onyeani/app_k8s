#!/bin/bash

kubectl cp grants.sql mariadb-0:/
kubectl cp db_script.sh mariadb-0:/
kubectl exec mariadb-0 ./db_script.sh

helm update
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
helm install mysql-exporter prometheus-community/prometheus-mysql-exporter -f values.yml 

echo 'setup complete. Forward port for grafana dashboard and monitor mariadb on your browser.'
