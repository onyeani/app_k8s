FROM webdevops/php-apache-dev

# Update apt repo
# Commented out to save time. Uncomment before final deployment.
#RUN apt update -y

# Update system.
# Commented out to save time. Uncomment before final deployment.
#RUN apt upgrade -y

# Copy app files from host to web server.
COPY ./addreview.php /app
COPY ./index.html /app

# Entrypoint
CMD ["supervisord"]
