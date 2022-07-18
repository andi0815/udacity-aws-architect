#!/bin/bash

terraform init
terraform plan -refresh=false -out=plan.tfplan
terraform show -json plan.tfplan | regula run
