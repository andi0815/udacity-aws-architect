#!/bin/bash

HOSTNAME=ec2-18-184-96-185.eu-central-1.compute.amazonaws.com
CERT_PATH=~/.ssh/udacity.pem
CERT_PATH=~/.ssh/udacity-fra.pem

ssh -i $CERT_PATH  ec2-user@$HOSTNAME
