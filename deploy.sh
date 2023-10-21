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
# Here we introduce and if statement to check for the status of apache2
if kubectl get deploy apache2 > /dev/null 2>&1
    then kubectl delete -f apache2.yml
    while kubectl get pod|grep -i apache2
        do sleep 3
    done
    kubectl apply -f apache2.yml
    else kubectl apply -f apache2.yml
fi

echo 'Creating mariadb statefulset and mariadb-svc...'
# I do this instead of using awk since I am using a statefulset and know the name.
DBPOD=mariadb-0
if kubectl get sts mariadb > /dev/null 2>&1
    then kubectl delete -f mariadb2.yml
    while kubectl get pod|grep -i mariadb
        do sleep 3
    done
    kubectl apply -f mariadb2.yml
    else kubectl apply -f mariadb2.yml
fi

# To grab podname dynamically, I use awk like so:
#export DBPOD=$(kubectl get pod | awk '/^mariadb/{print $1}')

# The command above first prints pods, and then tells awk to print the first field of the 
# line beginning with mariadb. Finally, I assign awk's output to the var $DBPOD
# Note: I suspect that by the time we get to this point, the DB pod might not be up and running.
# To guard against this, I introduce a loop, in this case the until loop.
# Which means our program will not progress until the cp commands succeed.

echo "Waiting for DB server to be ready for connections..."
until kubectl logs $DBPOD 2>/dev/null | grep -i "ready for connections" > /dev/null 2>&1; do sleep 10; done
echo "DB says it's ready for connections, but we sleep for 10s for safety."
# The reason I decided to sleep for 10s is because when I looked at the logs,
# I obeserved that the DB said it was ready for connections at two instances that are about 7s apart.
sleep 10
echo 'Done sleeping. We should be good to go.'
echo 'Moving files to DB server...'
# In the next line of code, we sleep for 5s if DB is still not ready for connections before checking again
# We leave the loop as soon as the cp command succeeds. I acknowledge this loop is not necessary 
# after the previous loop, but I add it for added safety. Might remove later.
until kubectl cp db_file.sql $DBPOD:/; do sleep 5; done

# Once we get past the previous loop, there'll be no need to put the second copy command in a loop 
# since it's safe to assume that for the first to be successful, then DB is really up and running.
kubectl cp db_script.sh $DBPOD:/
echo 'Files copied successfully...'

echo 'Creating db, table, user and whatnot...'
kubectl exec $DBPOD -- ./db_script.sh
echo 'db, table, user, whatnot creation successful'

# Next we enable ingress addon and configure ingress for our app
# For some reason the following command that enables ingress keeps making the system
# panic when run from jenkins. I had to comment it out to avoid.
# Besides we don't need that in the pipeline, since it's not something we do always.
#minikube addons enable ingress
kubectl apply -f app-ingress.yml

export WEBPOD=$(kubectl get pod | awk '/^apache2/{print $1}')
until kubectl logs $WEBPOD 2>/dev/null | grep -i 'ready to handle connections' > /dev/null 2>&1;
do echo "Webserver isn't ready to handle connections"; sleep 10; done
echo "Webserver ready. Map app.com to node's IP in /etc/hosts file and thereafter point browser to app.com to access app."
# NB. In production, we would be using our registered domain name here
# which has been mapped to our public IP
