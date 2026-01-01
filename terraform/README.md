# Terraform Design

Terraform design to store the component and design of Terraform on mono repository.

- `environments` directory to store the Terraform blueprint to plan/apply IaC.
- `modules` directory to store the set of custom component for Terraform (reusable source).

[!CAUTION]
- For module/component we can use the community/official module from providers to reduce the mantainace the custom resource.
- This projec will create some custom component to simulate the configuration of relationship between the custom module and blueprint.
- Regarding to follow the best pracetice, the component/module should have the revision control of the version of module.
- Terraform backend store the statefile of configuration should be limited the policy to access. It stores sensitive information.

## Some of list of the provider modules.
- ![AWS Providers](https://registry.terraform.io/namespaces/terraform-aws-modules)
