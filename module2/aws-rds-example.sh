#!/bin/bash
set -e

echo "Create DB instance ..."
aws rds create-db-instance \
    --db-instance-identifier udacity-cli \
    --db-instance-class db.t3.micro \
    --engine postgres \
    --engine-version 14.2 \
    --allocated-storage 20 \
    --master-username foo \
    --master-user-password foobarbaz

echo "Hit <ENTER> to delete DB instance ..."
read
aws rds delete-db-instance \
    --db-instance-identifier udacity-cli \
    --skip-final-snapshot \
    --delete-automated-backups