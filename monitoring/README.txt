README.txt

I have decided to remove monitoring from the pipeline since it isn't something
that need to be configured configured continuously.

I have configured monitoring for my mariadb database using prometheus.
In this folder, I have included all the files and scripts needed to complete the config.
I am using mysql-exporter to scrap data from the db and I have set this up with a helm chart.
