#!/bin/bash
# test.sh
# Commands for testing
echo "Testing docker image just created ..."
echo 'Starting up a container from image just created...'
docker run -d -p8091:80 --name webserver onyeani/apache2:1.0
echo 'Checking to see if webserver is up and running... should see home page...'
# curl returns an error saying connection closed by peer.
# This is because the server is still initialising when the request is made.
# For this reason, I have put this request in a loop and redirected 
# standard error to /dev/null
until curl http://localhost:8091 2>/dev/null; do echo 'server not ready' 1>/dev/null; done
echo 'Shutting down and removing webserver'
docker stop webserver
docker rm webserver