README.md
# app_k8s

=== from /dev/null to the cloud ===

This is a little project I undertook along the way as I journeyed
from the depths into the cloud.

It's a simple program that requests for user feedback.

This program makes use of a simple HTML form to collect user input, and then uses 
php to process that data before storing it in a mariadb database.

Let me briefly outline the steps I took to complete this project.

1. To begin, I created a docker image using webdevops/php-apache-dev as base, and then pushed this image 
to docker hub.
2. Then I installed and confiured minikube.
3. I pulled my docker image and a mariadb image from dockerhub and deployed the app in minikube.
4. Satisfied with the way everything was working, I decided to configure data persistence for 
the mariadb statefulset using nfs.
5. With that out of the way, I set up monitoring of the db using prometheus. I deployed prometheus and 
mysql exporter with the help of helm charts in order to reduce the complexity of the deployment. Once done with the setup, 
I was able to visualise the monitoring with grafana UI.
6. With the monitoring in place and everything looking good, I installed jenkins, pushed my code to github and then constructed a simple pipeline for my project.

As soon as the pipeline was in place, I realised its importance. Before the pipeline, I had to do everything
all over whenever I made a change, no matter how small. But the tedium was gone as soon as I implemented it.
The realisation of the pipeline's importance is reminiscent of the feeling I got when I first figured out the value and purity of the 
*nix shell.

With the help and support of a friend, I began this DevOps journey. 
So far it's been a mixture of triumphs and setbacks, but exciting nonetheless. How far will I travel? That remains to be seen. But I hope good things are coming.

At the right time, I will pay tribute to this friend. Until then, all I can say is that, he provided the inspiration for this, and I thank him.
