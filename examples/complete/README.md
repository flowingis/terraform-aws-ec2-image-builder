# EC2-Image-Builder

This example will manage the creation of EC2 Image builder with the creation of an iam role and Bucket S3 for logs.

## Usage

To run this example, you need to execute the following commands:

```shell
$ terraform init
$ terraform plan
$ terraform apply
```

:memo: **Note:** You will need a Terraform Cloud/Enterprise API token for authentication.
You'll be prompted to insert it to provide a value for "tfc_token" variable.
See [here](https://www.terraform.io/cloud-docs/users-teams-organizations/api-tokens)
for further information.

:memo: **Note:** This root modules defines other several sensitive variables.
You'll be prompted to insert the required values by default on every "plan" and "apply" action
Choose the appropriate method to automatically specify these values, like described [here](https://www.terraform.io/language/values/variables#assigning-values-to-root-module-variables)

:warning: **Warning:** This example may create resources that cost money. Execute the command
`terraform destroy` when the resources are no longer needed.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_tfe"></a> [aws](#requirement\aws)                    | >= 4.20  |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.20 |

## Modules

| Name                                                                                  | Source | Version |
|---------------------------------------------------------------------------------------|--------|---------|
| <a name="module_advanced_workspace"></a> [imagebuilder](#module\_advanced\_workspace) | ../../ | n/a     |

## Resources

| Name                                                                                                                                                       | Type     |
|------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_iam_role.iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                              | resource |
| [aws_iam_instance_profile.istance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_alias)                  | resource |
| [aws_iam_role_policy_attachment.policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)       | resource |
| [aws_s3_bucket.bucket_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)                                         | resource |
| [aws_s3_bucket_public_access_block.bucket_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_acl.bucket_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl)                                 | resource |

## Inputs

| Name                                                                                     | Description                                              | Type     | Default | Required |
|------------------------------------------------------------------------------------------|----------------------------------------------------------|----------|---------|:--------:|
| <a name="input_region"></a> [region](#input\_region)                                     | Region where resources are created                       | `string` | `n/a`   |   yes    |
| <a name="input_name"></a> [name](#input\_name)                                           | Generic resource name                                    | `string` | `n/a`   |   yes    |
| <a name="input_account_id"></a> [account\_id](#account\_id)                              | The account ID used in the launch template configuration | `string` | `n/a`   |   yes    |
| <a name="launch_template_id_1"></a> [launch\_template\_id\_1](#ilaunch\_template\_id\_1) | The ID of the Amazon EC2 launch template one             | `string` | `n/a`   |   yes    |
| <a name="launch_template_id_2"></a> [launch\_template\_id\_2](#ilaunch\_template\_id\_2) | The ID of the Amazon EC2 launch template two             | `string` | `n/a`   |   yes    |
| <a name="input_tfc_token"></a> [user\_ids](#iuser\_ids)                                  | Set of AWS Account user in the launch_permission         | `string` | `n/a`   |   yes    |

## Outputs

| Name                                                                                                                                     | Description                                     |
|------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| <a name="output_component"></a> [component](#output\_component)                                                                          | Map of Component                                |
| <a name="output_component_name"></a> [component\_name](#output\_component\_name)                                                         | List of Name of the component                   |
| <a name="output_component_arn"></a> [component\_arn](#output\_component\_arn)                                                            | List of Arn of the component                    |
| <a name="output_image_recipe_arn"></a> [image\_recipe\_arn](#output\_image\_recipe\_arn)                                                 | Amazon Resource Name (ARN) of the image recipe  |
| <a name="output_infrastructure_configuration_arn"></a> [infrastructure\_configuration\_arn](#output\_infrastructure\_configuration\_arn) | arn of the infrastructure configuration         |
| <a name="output_distribution_configuration_name"></a> [distribution\_configuration\_name](#output\_distribution\_configuration\_name)    | Name of the distribution configuration          |
| <a name="output_image_pipeline_arn"></a> [image\_pipeline\_arn](#output\_image\_pipeline\_arn)                                           | Name of the distribution configuration          |  
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->