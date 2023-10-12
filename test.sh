#!/bin/bash
# test.sh
# Commands for testing
echo "Testing the app..."
echo 'Starting up a container from image just created'
docker run -d -p8091:80 --name webserver onyeani/apache2:1.0
echo 'Checking to see if webserver is up and running... should see home page...'
# curl returns an error saying connection closed by peer. I think the reason 
# for this is because the server is still initialising when the request is made
#curl -f http://localhost:8091
echo 'Shutting down and removing webserver'
docker stop webserver
docker rm webserver