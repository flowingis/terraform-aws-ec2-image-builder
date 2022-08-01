variable "name" {
  description = "Generic resource name"
  type        = string
}

variable "components" {
  description = "Image Builder Component"
  type        = any
  default     = {}
}

variable "create_image_recipe" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "image_recipe_parent_image" {
  description = "Platform of the image recipe"
  type        = string
}

variable "image_recipe_version" {
  description = "Version of the image recipe"
  type        = string
}

variable "block_device_mapping" {
  description = "Configuration block(s) with block device mappings for the image recipe. Detailed below"
  type        = list(map(string))
  nullable    = true
  default     = []
}

variable "component_external_arns" {
  description = ""
  type        = list(string)
  default     = []
}

variable "ebs" {
  description = "Configuration block with Elastic Block Storage (EBS) block device mapping settings"
  type        = list(map(string))
  nullable    = true
  default     = []
}

variable "enable_resource_tags" {
  description = "Whether to enable resource tags"
  type        = bool
  default     = false
}

variable "resource_tags" {
  description = "Key-value map of resource tags to assign to infrastructure created by the configuration"
  type        = map(string)
  default     = {}
}

variable "create_infrastructure_configuration" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "infrastructure_configuration_description" {
  description = "Description for the configuration"
  type        = string
  default     = null
}

variable "infrastructure_configuration_instance_profile_name" {
  description = "Name of IAM Instance Profile"
  type        = string
}

variable "infrastructure_configuration_instance_types" {
  description = "EC2 Instance Types"
  type        = list(string)
  nullable    = true
  default     = ["t3.nano", "t3.micro"]
}

variable "infrastructure_configuration_key_pair" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = null
}

variable "infrastructure_configuration_security_group_ids" {
  description = "EC2 Security Group identifiers"
  type        = list(string)
  default     = null
}

variable "infrastructure_configuration_sns_topic_arn" {
  description = "Amazon Resource Name (ARN) of SNS Topic"
  type        = string
  default     = null
}

variable "infrastructure_configuration_subnet_id" {
  description = "EC2 Subnet identifier. Also requires security_group_ids argument"
  type        = string
  default     = null
}

variable "infrastructure_configuration_terminate_instance_on_failure" {
  description = "Enable if the instance should be terminated when the pipeline fails"
  type        = bool
  default     = false
}

variable "infrastructure_configuration_s3_logs_enabled" {
  description = "Whether to enable s3 logs"
  type        = bool
  default     = false
}

variable "infrastructure_configuration_s3_bucket_name" {
  description = "Name of the S3 Bucket."
  type        = string
  default     = null
}

variable "infrastructure_configuration_s3_key_prefix" {
  description = "Prefix to use for S3 logs"
  type        = string
  default     = null
}

variable "create_distribution_configuration" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "distribution_configuration_description" {
  description = "Description of the distribution configuration"
  type        = string
  default     = null
}

variable "distribution_configuration_kms_key_id" {
  description = "Amazon Resource Name (ARN) of the Key Management Service (KMS) Key used to encrypt the distribution configuration"
  type        = string
  default     = null
}

variable "distribution_configuration_region" {
  description = "AWS Region for the distribution"
  type        = string
}

variable "ami_distribution_configuration" {
  description = "Configuration block with Amazon Machine Image (AMI) distribution settings"
  type        = any
  default     = {}
}

variable "launch_permission" {
  description = "Configuration block of EC2 launch permissions to apply to the distributed AMI"
  type        = map(list(string))
  default     = {}
}

variable "fast_launch_configuration" {
  description = "Set of Windows faster-launching configurations to use for AMI distribution"
  type        = map(string)
  default     = {}
}

variable "launch_template" {
  description = "Configuration block for the launch template that the fast-launch enabled Windows AMI uses when it launches Windows instances to create pre-provisioned snapshots"
  type        = map(string)
  default     = null
}

variable "launch_template_configuration" {
  description = "Set of launch template configuration settings that apply to image distribution"
  type        = map(string)
  default     = null
}

variable "image_pipeline" {
  description = "Controls whether resources should be created"
  type        = bool
  default     = true
}

variable "image_pipeline_description" {
  description = "Description of the image pipeline"
  type        = string
  default     = null
}

variable "image_pipeline_enhanced_image_metadata_enabled" {
  description = "Whether additional information about the image being created is collected"
  type        = bool
  default     = true
}

variable "image_pipeline_status" {
  description = "Status of the image pipeline,Valid values are DISABLED and ENABLED"
  type        = string
  default     = "ENABLED"
}

variable "image_tests_configuration" {
  description = "Configuration block with image tests configuration"
  type        = map(string)
  default     = {}
}

variable "image_tests_configuration_schedule_enabled" {
  description = "Whether to enable schedule expression"
  type        = bool
  default     = false
}

variable "image_tests_configuration_schedule_expression" {
  description = "Cron expression of how often the pipeline start condition is evaluated"
  type        = string
  default     = null
}

variable "image_recipe_arn" {
  description = "Amazon Resource Name (ARN) of the image recipe"
  type        = string
  default     = ""
}

variable "infrastructure_configuration_arn" {
  description = "mazon Resource Name (ARN) of the Image Builder Infrastructure Configuration"
  type        = string
  default     = ""
}

variable "distribution_configuration_arn" {
  description = "Amazon Resource Name (ARN) of the Image Builder Distribution"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}