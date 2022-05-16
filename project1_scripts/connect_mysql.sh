#!/bin/bash

export MYSQL_SERVER=udacity-project-primary.cu1yvorshmgl.us-east-1.rds.amazonaws.com
export MYSQL_SERVER=udacity-secondary-standby.cmcuv2bedge2.eu-central-1.rds.amazonaws.com
export MYSQL_PORT=3306


sudo yum update
sudo yum install mysql
mysql -u admin -p -h $MYSQL_SERVER --port $MYSQL_PORT
