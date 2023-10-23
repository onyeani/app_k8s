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
to my account on Dockerhub.
2. Then I installed and confiured minikube.
3. I pulled my docker image and a mariadb image from dockerhub and deployed the app in minikube.
4. Satisfied with the way everything was working, I decided to configure data persistence for 
the mariadb statefulset using nfs.
5. With that out of the way, I set up monitoring of the db using prometheus. I deployed prometheus and 
mysql exporter with the help of helm charts in order to reduce the complexity of the deployment. Once done with the setup, 
I was able to visualise the monitoring with grafana UI.
6. With the monitoring in place and everything looking good, I installed Jenkins, pushed my code to github and then constructed a simple pipeline for my project.

With everything looking good, I decided to deploy my project in a cloud environment to see how everything works. So I setup a kubernetes cluster using kubeadm on two AWS EC2 instances, one as the the control plane and the other as a worker node. Once the cluster was up and looking good, I launched another EC2 instance which I used as my nfs server in order to configure data persistence for the mariadb statefulset. And finally, I used GitHub Actions to construct a pipeline for the entire project. Once there is a pull request or push to the main branch, the job executes. This involves building the docker image, pushing the built image to my Dockerhub repo and finally deploying the project to my kubernetes cluster on AWS.

As soon as the pipeline was in place, I realised its importance. Before the pipeline, I had to do everything
all over whenever I made a change, no matter how small. But the tedium was gone as soon as I implemented it.
The realisation of the pipeline's importance is reminiscent of the feeling I got when I first figured out the value and purity of the shell. 

