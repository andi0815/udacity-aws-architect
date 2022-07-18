#!/bin/bash

# Links:
# - https://regula.dev/index.html
# - https://regula.dev/rules.html#aws-terraform


terraform init
terraform plan -refresh=false -out=plan.tfplan
terraform show -json plan.tfplan | regula run
