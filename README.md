# EC2-Image-Builder
Terraform module that creates and manages an Amazon Machine Image (AMI) with EC2 Image Builder service. 

:warning: The module initially only manages the creation of AMIs and not Container Image.

## Usage

### Simple workspace with local run mode
```
module "imagebuilder" {
  source = "../../"

  name = var.name

  components = [
    {
      "data" = yamlencode({
        phases = [
          {
            name = "build"
            steps = [
              {
                action = "ExecuteBash"
                inputs = {
                  commands = ["echo 'hello world'"]
                }
                name      = "helloworld"
                onFailure = "Continue"
              }
            ]
          }
        ]
        schemaVersion = 1.0
      }),
      "name"        = "hello world",
      "description" = "component hello world",
      "version"     = "1.0.0"
    }
  ]

  component_external_arns = ["arn:aws:imagebuilder:${var.region}:aws:component/amazon-cloudwatch-agent-linux/1.0.1/1"]

  image_recipe_parent_image = "arn:${data.aws_partition.current.partition}:imagebuilder:${var.region}:aws:image/ubuntu-server-20-lts-x86/2022.3.8"
  image_recipe_version      = "1.0.0"

  block_device_mapping = [
    {
      device_name           = "/dev/sda"
      delete_on_termination = true
      volume_size           = 10
      volume_type           = "gp3"
    }
  ]

  infrastructure_configuration_instance_profile_name = aws_iam_instance_profile.istance_profile.name
  infrastructure_configuration_instance_types        = ["t3.nano"]

  infrastructure_configuration_s3_logs_enabled = false
  infrastructure_configuration_s3_bucket_name  = aws_s3_bucket.bucket_logs.bucket

  enable_resource_tags = true
  resource_tags        = local.common_tags


  distribution_configuration_region = var.region

  ami_distribution_configuration = {
    name = var.name

    ami_tags = {
      CostCenter = "IT"
    }

  }

  launch_permission = {
    user_ids = var.user_ids
  }

  launch_template_configuration = [
    {
      launch_template_id = var.launch_template_id_1
      account_id         = var.account_id
    },
    {
      launch_template_id = var.launch_template_id_2
      account_id         = var.account_id
    }
  ]

  image_tests_configuration_schedule_enabled    = true
  image_tests_configuration_schedule_expression = "cron(0 0 * * ? *)"
}
```
## Examples

- [Complete EC2-Image-Builder](https://github.com/flowingis/terraform-aws-imagebuilder/tree/master/examples/complete)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws)                   | >= 4.20  |

## Providers

| Name                                              | Version |
|---------------------------------------------------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.20 |

## Modules

No modules.

## Resources

| Name                                                                                                                                                                        | Type     |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [aws_imagebuilder_component.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_component)                                       | resource |
| [aws_imagebuilder_image_recipe.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_recipe)                                 | resource |
| [aws_imagebuilder_infrastructure_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_infrastructure_configuration) | resource |
| [aws_imagebuilder_distribution_configurations.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_distribution_configuration)    | resource |
| [aws_imagebuilder_image_pipeline.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/imagebuilder_image_pipeline)                             | resource |

## Inputs

| Name                                                                                                                                                                                                                  | Description                                                                                                                                                      | Type                | Default                   | Required |
|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|---------------------------|:--------:|
| <a name="name"></a> [name](#input\_name)                                                                                                                                                                              | Generic resource name                                                                                                                                            | `string`            | `n/a`                     |   yes    |
| <a name="components"></a> [components](#input\_components)                                                                                                                                                            | Image Builder Component                                                                                                                                          | `any`               | `{}`                      |    no    |
| <a name="input_create_image_recipe"></a> [create\_image\_recipe](#input\_create\_image\_recipe)                                                                                                                       | Controls whether resources should be created                                                                                                                     | `bool`              | `true`                    |    no    |
| <a name="input_image_recipe_parent_image"></a> [image\_recipe\_parent\_image](#input\_image\_recipe\_parent\_image)                                                                                                   | Platform of the image recip                                                                                                                                      | `string`            | `n/a`                     |   yes    |
| <a name="input_image_recipe_version"></a> [image\_recipe\_version](#input\_image\_recipe\_version)                                                                                                                    | Version of the image recipe                                                                                                                                      | `string`            | `n/a`                     |   yes    |
| <a name="block_device_mapping"></a> [block\_device\_mapping](#input\_block\_device\_mapping)                                                                                                                          | Configuration block(s) with block device mappings for the image recipe. Detailed below                                                                           | `list(map(string))` | `[]`                      |    no    |
| <a name="component_external_arns"></a> [component\_external\_arns](#input\_component\_external\_arns)                                                                                                                 | Components created externally                                                                                                                                    | `list(string)`      | `[]`                      |    no    |
| <a name="ebs"></a> [ebs](#input\_ebs)                                                                                                                                                                                 | Configuration block with Elastic Block Storage (EBS) block device mapping settings                                                                               | `list(map(string))` | `[]`                      |    no    |
| <a name="enable_resource_tags"></a> [enable\_resource\_tags](#input\_enable\_resource\_tags)                                                                                                                          | Whether to enable resource tags                                                                                                                                  | `bool`              | `false`                   |    no    |
| <a name="resource_tags"></a> [resource\_tags](#input\_resource\_tags)                                                                                                                                                 | Key-value map of resource tags to assign to infrastructure created by the configuration                                                                          | `map(string)`       | `{}`                      |    no    |
| <a name="create_infrastructure_configuration"></a> [create\_infrastructure\_configuration](#input\_create\_infrastructure\_configuration)                                                                             | Controls whether resources should be created                                                                                                                     | `bool`              | `true`                    |    no    |
| <a name="infrastructure_configuration_description"></a> [infrastructure\_configuration\_description](#input\_infrastructure\_configuration\_description)                                                              | Description for the configuration                                                                                                                                | `string`            | `null`                    |    no    |
| <a name="infrastructure_configuration_instance_profile_name"></a> [infrastructure\_configuration\_instance\_profile\_name](#input\_infrastructure\_configuration\_instance\_profile\_name)                            | Name of IAM Instance Profile                                                                                                                                     | `string`            | `n/a`                     |   yes    |
| <a name="infrastructure_configuration_instance_types"></a> [infrastructure\_configuration\_instance\_types](#input\_infrastructure\_configuration\_instance\_types)                                                   | EC2 Instance Types                                                                                                                                               | `list(string)`      | `["t3.nano", "t3.micro"]` |    no    |
| <a name="infrastructure_configuration_key_pair"></a> [infrastructure\_configuration\_key\_pair](#input\_infrastructure\_configuration\_key\_pair)                                                                     | Name of EC2 Key Pair                                                                                                                                             | `string`            | `null`                    |    no    |
| <a name="infrastructure_configuration_security_group_ids"></a> [infrastructure\_configuration\_security\_group\_ids](#input\_infrastructure\_configuration\_security\_group\_ids)                                     | EC2 Security Group identifiers                                                                                                                                   | `list(string)`      | `null`                    |    no    |
| <a name="infrastructure_configuration_sns_topic_arn"></a> [infrastructure\_configuration\_sns\_topic\_arn](#input\_infrastructure\_configuration\_sns\_topic\_ar)                                                     | Amazon Resource Name (ARN) of SNS Topic                                                                                                                          | `string`            | `null`                    |    no    |
| <a name="infrastructure_configuration_subnet_id"></a> [infrastructure\_configuration\_subnet\_id](#input\_infrastructure\_configuration\_subnet\_id)                                                                  | EC2 Subnet identifier. Also requires security_group_ids argument                                                                                                 | `string`            | `null`                    |    no    |
| <a name="infrastructure_configuration_terminate_instance_on_failure"></a> [infrastructure\_configuration\_terminate\_instance\_on\_failure](#input\_infrastructure\_configuration\_terminate\_instance\_on\_failure]) | Enable if the instance should be terminated when the pipeline fails                                                                                              | `bool`              | `false`                   |    no    |
| <a name="infrastructure_configuration_s3_logs_enabled"></a> [infrastructure\_configuration\_s3\_logs\_enabled](#input\_infrastructure\_configuration\_s3\_logs\_enabled)                                              | Whether to enable s3 logs                                                                                                                                        | `bool`              | `false`                   |    no    |
| <a name="infrastructure_configuration_s3_bucket_name"></a> [infrastructure\_configuration\_s3\_bucket\_name"](#input\_infrastructure\_configuration\_s3\_bucket\_name)                                                | Name of the S3 Bucket                                                                                                                                            | `string`            | `null`                    |    no    |
| <a name="infrastructure_configuration_s3_key_prefix"></a> [infrastructure\_configuration\_s3\_key\_prefix](#input\_infrastructure\_configuration\_s3\_key\_prefix)                                                    | Prefix to use for S3 logs                                                                                                                                        | `string`            | `null`                    |    no    |
| <a name="create_distribution_configuration"></a> [create\_distribution\_configuration](#input\_create\_distribution\_configuration)                                                                                   | Controls whether resources should be created                                                                                                                     | `bool`              | `true`                    |    no    |
| <a name="distribution_configuration_description"></a> [distribution\_configuration\_description](#input\_distribution\_configuration\_description)                                                                    | Description of the distribution configuration                                                                                                                    | `string`            | `null`                    |    no    |
| <a name="distribution_configuration_kms_key_id"></a> [distribution\_configuration\_kms\_key\_id](#input\_distribution\_configuration\_kms\_key\_id)                                                                   | Amazon Resource Name (ARN) of the Key Management Service (KMS) Key used to encrypt the distribution configuration                                                | `string`            | `null`                    |    no    |
| <a name="distribution_configuration_region"></a> [distribution\_configuration\_region](#input\_distribution\_configuration\_region)                                                                                   | AWS Region for the distribution                                                                                                                                  | `string`            | `n/a`                     |   yes    |
| <a name="ami_distribution_configuration"></a> [ami\_distribution\_configuration](#input\_ami\_distribution\_configuration)                                                                                            | Configuration block with Amazon Machine Image (AMI) distribution settings                                                                                        | `any`               | `{}`                      |    no    |
| <a name="launch_permission"></a> [launch\_permission](#input\_launch\_permission)                                                                                                                                     | Configuration block of EC2 launch permissions to apply to the distributed AMI                                                                                    | `map(list(string))` | `{}`                      |    no    |
| <a name="fast_launch_configuration"></a> [fast\_launch\_configuration](#input\_fast\_launch\_configuration)                                                                                                           | Set of Windows faster-launching configurations to use for AMI distribution                                                                                       | `map(string)`       | `{}`                      |    no    |
| <a name="launch_template"></a> [launch\_template](#input\_launch\_template)                                                                                                                                           | Configuration block for the launch template that the fast-launch enabled Windows AMI uses when it launches Windows instances to create pre-provisioned snapshots | `map(string)`       | `null`                    |    no    |
| <a name="launch_template_configuration"></a> [launch\_template\_configuratio](#input\_launch\_template\_configuratio)                                                                                                 | Set of launch template configuration settings that apply to image distribution                                                                                   | `list(map(string))` | `[]`                      |    no    |
| <a name="image_pipeline"></a> [image\_pipeline](#input\_image\_pipeline)                                                                                                                                              | Controls whether resources should be created                                                                                                                     | `bool`              | `true`                    |    no    |
| <a name="image_pipeline_description"></a> [image\_pipeline\_description](#input\_image\_pipeline\_description)                                                                                                        | Description of the image pipeline                                                                                                                                | `string`            | `null`                    |    no    |
| <a name="image_pipeline_enhanced_image_metadata_enabled"></a> [image\_pipeline\_enhanced\_image\_metadata\_enabled](#input\_image\_pipeline\_enhanced\_image\_metadata\_enabled)                                      | Whether additional information about the image being created is collected                                                                                        | `bool`              | `true`                    |    no    |
| <a name="image_pipeline_status"></a> [image\_pipeline\_status](#input\_image\_pipeline\_status)                                                                                                                       | Status of the image pipeline,Valid values are DISABLED and ENABLED                                                                                               | `string`            | `ENABLED`                 |    no    |
| <a name="image_tests_configuration"></a> [image\_tests\_configuration](#input\_image\_tests\_configuration)                                                                                                           | Configuration block with image tests configuration                                                                                                               | `map(string)`       | `{}`                      |    no    |
| <a name="image_tests_configuration_schedule_enabled"></a> [image\_tests\_configuration\_schedule\_enabled](#input\_image\_tests\_configuration\_schedule\_enabled)                                                    | Whether to enable schedule expression                                                                                                                            | `bool`              | `false`                   |    no    |
| <a name="image_tests_configuration_schedule_expression"></a> [image\_tests\_configuration\_schedule\_expression](#input\_image\_tests\_configuration\_schedule\_expression)                                           | Cron expression of how often the pipeline start condition is evaluated                                                                                           | `string`            | `null`                    |    no    |
| <a name="image_recipe_arn"></a> [image\_recipe\_arn](#input\_image\_recipe\_arn)                                                                                                                                      | Amazon Resource Name (ARN) of the image recipe                                                                                                                   | `string`            | `n/a`                     |    no    |
| <a name="infrastructure_configuration_arn"></a> [infrastructure\_configuration\_arn](#input\_infrastructure\_configuration\_arn)                                                                                      | Amazon Resource Name (ARN) of the Image Builder Infrastructure Configuration                                                                                     | `string`            | `n/a`                     |    no    |
| <a name="distribution_configuration_arn"></a> [distribution\_configuration\_arn](#input\_distribution\_configuration\_arn)                                                                                            | Amazon Resource Name (ARN) of the Image Builder Distribution                                                                                                     | `string`            | `n/a`                     |    no    |
| <a name="tags"></a> [tags](#input\_tags)                                                                                                                                                                              | A mapping of tags to assign to the resource                                                                                                                      | `map(string)`       | `{}`                      |    no    |

## Outputs

| Name                                                                                                                                                                                        | Description                                               |
|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------|
| <a name="component"></a> [component](#output\_component)                                                                                                                                    | Map of Component                                          |
| <a name="component_name"></a> [component\_name](#output\_component\_name)                                                                                                                   | List of Name of the component                             |
| <a name="component_arn"></a> [component\_arn](#output\_component\_arn)                                                                                                                      | List of Arn of the component                              |
| <a name="image_recipe_name"></a> [image\_recipe\_name](#output\_image\_recipe\_name)                                                                                                        | Name of the image recipe                                  |
| <a name="image_recipe_component"></a> [image\_recipe\_component](#output\_image\_recipe\_component)                                                                                         | Name of the image recipe                                  |
| <a name="image_recipe_arn"></a> [image\_recipe\_arn](#output\_image\_recipe\_arn)                                                                                                           | Amazon Resource Name (ARN) of the image recipe            |
| <a name="image_recipe_owner"></a> [image\_recipe\_owner](#output\_image\_recipe\_owner)                                                                                                     | Owner of the image recipe                                 |
| <a name="infrastructure_configuration_name"></a> [infrastructure\_configuration\_name](#output\_infrastructure\_configuration\_name)                                                        | Name of the infrastructure configuration                  |
| <a name="infrastructure_configuration_arn"></a> [infrastructure\_configuration\_arn](#output\_infrastructure\_configuration\_arn)                                                           | Arn of the infrastructure configuratio                    |
| <a name="infrastructure_configuration_instance_profile_name"></a> [infrastructure\_configuration\_instance\_profile\_name](#output\_infrastructure\_configuration\_instance\_profile\_name) | Instance Profile name of the infrastructure configuration |
| <a name="infrastructure_configuration_instance_types"></a> [infrastructure\_configuration\_instance\_types](#output\_infrastructure\_configuration\_instance\_types)                        | Instance Types of the infrastructure configuration        |
| <a name="distribution_configuration_name"></a> [distribution\_configuration\_name](#output\_distribution\_configuration\_name)                                                              | Name of the distribution configuration                    |
| <a name="image_pipeline_name"></a> [image\_pipeline\_name](#output\_image\_pipeline\_name)                                                                                                  | Name of the image pipeline                                |
| <a name="image_pipeline_arn"></a> [image\_pipeline\_arn](#output\_image\_pipeline\_arn)                                                                                                     | Arn of the image pipeline                                 |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->