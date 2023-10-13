#!/bin/bash
# deploy.sh

echo 'Deploying app ...'
# First, we prepare environment by creating secrets, configsmaps...
echo 'Creating configmap and secrets'
kubectl apply -f mariadb-configmap.yml
kubectl apply -f mariadb-secret.yml

# Our persistent volume uses nfs
# We have already installed nfs-kernel-server on the machine 
# we are using as our nfs server and have exported the dirs we 
# are making available with the pv
echo 'Creating persitent volume for the webserver and db'
kubectl apply -f apache2-pv.yml
kubectl apply -f mariadb-pv.yml

echo 'Creating persistent volume claim for webserver and db'
kubectl apply -f apache2-pvc.yml
kubectl apply -f mariadb-pvc.yml

echo 'Creating apache2 and apache2-svc'
# The k8s manifest file 'apache2.yml' contains instructions
# for creating apache2 and apache2-svc  
kubectl apply -f apache2.yml

echo 'Creating mariadb statefulset and mariadb-svc...'
kubectl apply -f mariadb.yml

echo 'Moving files to db server...'
# Move files from host to db server
# To grab podname dynamically, I use awk like so:
export DBPOD=$(kubectl get pod | awk '/^mariadb/{print $1}')
# The command above first prints pods, and then tells awk to print the first field of the 
# line beginning with mariadb. Finally, I assign awk's output to the var $DBPOD
### Note: I suspect that by the time we get to this point, the DB pod might not be up and running.
# To guard against this, I introduce a loop, in this case the until loop.
# Which means our program will not progress until the cp commands succeed.
until kubectl cp db_file.sql $DBPOD:/ 2>/dev/null; do echo 'server not ready' 1>/dev/null; done

# Once we get past the previous loop, there'll be no need to put the second copy command in a loop 
# since it's safe to assume that for the first to be successful, then db is up and running.
kubectl cp db_script.sh $DBPOD:/
echo 'Files copied successfully...'

echo 'Creating db, table, user and whatnot...'
until kubectl exec $DBPOD ./db_script.sh 2>/dev/null; do echo 'server not ready' 1>/dev/null; done
#kubectl exec $DBPOD ./db_script.sh
echo 'db, table, user, whatnot creation successful'

# Next we enable ingress addon and configure ingress for our app
minikube addons enable ingress
kubectl apply -f app-ingress.yml
echo "Done. Map app.com to node's IP in /etc/hosts file."
echo "Point browser to app.com to access app."
# NB. In production, we would be using our registered domain name here
# which has been mapped to our public IP
