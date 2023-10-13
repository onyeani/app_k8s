#!/bin/bash
# build.sh
# This script holds the commands for building my own docker image
# After building, the image is then uploaded/pushed to my repo on docker hub.
# Later, during the deploy stage, we pull this image and a mariadb image
# from docker hub to finally deploy our app in a k8s cluster.
echo "Building container has just commenced..."
# Here, the docker build command looks for a file named 'Dockerfile'
# in the pwd, and with the instructions contained in it, builds an 
# image called apache2 with tag 1.0
docker build -t apache2:1.0 .
echo 'tagging image just built with my docker ID'
docker tag apache2:1.0 onyeani/apache2:1.0
# To push image to docker hub, user must first be logged in to docker hub
# To login, issue: 'docker login' on commandline, and then provide login credentials
echo "Pushing image to docker hub"
docker push onyeani/apache2:1.0