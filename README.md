README.md
# app_k8s

=== from /dev/null to the cloud ===

This is a little project I did along the way as I made my way 
from the depths into the cloud.

I wrote a simple program in which I ask users to rate this app.

This program makes use of a simple html form to collect user input, and then uses 
php to process that data before storing it in a mariadb database.

Let me briefly outline the steps I took to complete this project.

1. To begin, I created a docker image using webdevops/php-apache-dev as base, and then pushed this image 
to docker hub.
2. Then I installed minikube.
3. I pulled my docker image and a mariadb image from dockerhub and deployed the app in minikube.
4. Satisfied with the way everything was working, I decided to configure data persistence for 
the mariadb statefulset.
5. With that out of the way, I set up monitoring of the db using prometheus. I deployed prometheus and 
mysql exporter with the help of helm charts in order to reduce the complexity of the deployment. Once done with the setup, 
I was able to visualise the monitoring with grafana UI.
6. With the monitoring in place and everything looking good, I installed jenkins, pushed my code to github and then 
constructed a pipeline for my project.

As soon as the pipeline was in place, I realised its importance. Before the pipeline, I had to do everything
all over whenever I made a change, no matter how small. But the tedium was gone as soon as I implemented the pipeline. 
The realisation of the pipeline's importance is reminiscent of the feeling I got when I first realised the value and purity of the 
*nix shell.

With the help and support of a friend, I began this DevOps journey. 
So far, it has been a mixture of triumphs and hair-pulling, but it seems exciting, and I hope good things are coming.

When the time comes, I will pay tribute to this friend. Until then, all I can say is that, he provided the inspiration for this, and I thank him.
