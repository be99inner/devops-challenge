# Terraform Sandbox Blueprint

- Deploy network with official vpc module (best practice with version)
- Deploy s3 module
- Create IAM of application

## TODO

- [ ] Improve the backend setup for Terraform. Using one of configurable of [Terraform Backend](https://developer.hashicorp.com/terraform/language/backend)
- [ ] Centralize management of Terraform, improve the configuration via server side plan and apply.
- [ ] Automate setup and deploy application with userdata/ansible.

> [!CAUTION]
> This blueprint control the traffic on application. It doesn't control the software inside the EC2 instance.
