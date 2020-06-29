# Terraforming ACI

![image](terraforming.jpg)

Cisco ACI comes with a powerful REST API that allows treating the infrastructure as code. Terraform is a tool designed and created by HashiCorp to automate provisioning and managing cloud and infrastructure resources. Bringing this capability on the table, configuring or re-building your infra is a matter of moments rather than hours. 

This repository contains a tenant configuration and variable file that you can run against ACI Sandbox or your own infratructure.

To start terraforming your networks:
- Download and install Terraform (<https://www.terraform.io/>)
- Clone this repo
- Check out the var.tf file and modify the variables for your tenants
- Run `terraform init` to get the needed providers
- Run `terraform plan` to see what changes are hitting the pipeline
- Run `terraform apply` when you are are ready to provision the configuration
- Finally if you want to delete your configuration run `terraform destroy`

Terraform tracks the state of the infrastructure and thus only provisions what has changed. 