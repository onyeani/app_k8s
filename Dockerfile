FROM webdevops/php-apache-dev

# Update apt repo
# Commented out to save data. Uncomment before final deployment.
#RUN apt update -y

# Update system.
# Commented out to save data. Uncomment before final deployment.
#RUN apt upgrade -y

# Copy app files from host m/c to web server.
COPY ./addreview.php /app
COPY ./index.html /app

# Entrypoint
CMD ["supervisord"]
