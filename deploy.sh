#!/bin/bash
# deploy.sh

echo 'deploying app ..'
# First, we prepare environment by creating screts, configsmaps, namespaces...
# place commands here
echo 'creating configmap and secrets'
kubectl apply -f mariadb-configmap.yml
kubectl apply -f mariadb-secret.yml

# Our persistent volume uses nfs
# We have already installed nfs-kernel-server on the machine 
# we are using as our nfs server and have exported the dirs we 
# are making available with the pv
echo 'creating persitent volume for the webserver and db'
kubectl apply -f apache2-pv.yml
kubectl apply -f mariadb-pv.yml

echo 'creating persistent volume claim for webserver and db'
kubectl apply -f apache2-pvc.yml
kubectl apply -f mariadb-pvc.yml


# Then we create apache2 and apache2-svc with the command that follows.
echo 'Creating apache2 and apache2-svc'
# The k8s manifest file 'apache2.yml' contains instructions
# for creating apache2 and apache2-svc  
kubectl apply -f apache2.yml
echo 'Creating mariadb statefulset and mariadb-svc'
kubectl apply -f mariadb.yml

echo 'moving files to db server'
# Move files from host to db server
kubectl cp db_file.sql mariadb-0:/
kubectl cp db_script.sh mariadb-0:/

# I'll create a separate script for monitoring.
#kubectl cp db_mysql_exporter.sql
echo 'creating db, table, user and whatnot...'
kubectl exec mariadb-0 ./db_script.sh

# Next we enable ingress addon and configure ingress for our app
minikube addons enable ingress
kubectl apply -f app-ingress.yml
echo "Done. Map app.com to node's ip in /etc/hosts file."
echo "Point browser to app.com to access app."
# NB. In production, we would be using our registered domain name here
# which has been mapped to our public IP
