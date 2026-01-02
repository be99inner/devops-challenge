# Terraform Sandbox Blueprint

- Deploy network with official vpc module (best practice with version)
- Deploy s3 module
- Create IAM of application

## Prerequisite

- Terraform

## Project Setup

```bash
terraform init
terraform plan
terraform apply
```

> [!CAUTION]
> This blueprint control the traffic on application. It doesn't control the software inside the EC2 instance.

## TODO

- [ ] Improve the backend setup for Terraform. Using one of configurable of [Terraform Backend](https://developer.hashicorp.com/terraform/language/backend)
- [ ] Centralize management of Terraform, improve the configuration via server side plan and apply.
- [ ] Automate setup and deploy application with userdata/ansible.
- [ ] Healthcheck setup via Terraform on each target group to ensure the traffic is reachable to target instance.
