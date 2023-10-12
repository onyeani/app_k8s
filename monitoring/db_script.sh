#!/bin/bash
# DB CREATION SCRIPT
# Please run this shell script on the container running mariadb 
# In order to create the DB, user and tables
mariadb --user=root --password=password --execute="source ./grants.sql;"
