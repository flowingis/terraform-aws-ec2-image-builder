variable "region" {
  description = "Region where resources are created"
  type        = string
}

variable "name" {
  description = "Generic resource name"
  type        = string
}

variable "account_id" {
  description = "The account ID used in the launch template configuration"
  type        = string
  sensitive   = true
}

variable "launch_template_id_1" {
  description = "The ID of the Amazon EC2 launch template one"
  type        = string
  sensitive   = true
}

variable "launch_template_id_2" {
  description = "The ID of the Amazon EC2 launch template two"
  type        = string
  sensitive   = true
}

variable "user_ids" {
  description = "Set of AWS Account user in the launch_permission"
  type        = list(string)
  sensitive   = true
}