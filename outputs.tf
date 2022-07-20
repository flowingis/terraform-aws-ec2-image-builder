output "component" {
  description = "Map of Component"
  value       = aws_imagebuilder_component.this
}

output "component_name" {
  description = "List of Name of the component."
  value       = [for k, v in aws_imagebuilder_component.this : v.name]
}

output "component_arn" {
  description = "List of Arn of the component."
  value       = [for k, v in aws_imagebuilder_component.this : v.arn]
}

output "image_recipe_name" {
  description = "Name of the image recipe"
  value       = try(aws_imagebuilder_image_recipe.this[0].name, "")
}

output "image_recipe_component" {
  description = "Name of the image recipe"
  value       = try(aws_imagebuilder_image_recipe.this[0].component, "")
}

output "image_recipe_arn" {
  description = "Amazon Resource Name (ARN) of the image recipe"
  value       = try(aws_imagebuilder_image_recipe.this[0].arn, "")
}

output "image_recipe_owner" {
  description = "Owner of the image recipe"
  value       = try(aws_imagebuilder_image_recipe.this[0].owner, "")
}

output "infrastructure_configuration_name" {
  description = "Name of the infrastructure configuration"
  value       = try(aws_imagebuilder_infrastructure_configuration.this[0].name, "")
}

output "infrastructure_configuration_arn" {
  description = "arn of the infrastructure configuration"
  value       = try(aws_imagebuilder_infrastructure_configuration.this[0].arn, "")
}

output "infrastructure_configuration_instance_profile_name" {
  description = "Instance Profile name of the infrastructure configuration"
  value       = try(aws_imagebuilder_infrastructure_configuration.this[0].instance_profile_name, "")
}

output "infrastructure_configuration_instance_types" {
  description = "Instance Types of the infrastructure configuration"
  value       = try(aws_imagebuilder_infrastructure_configuration.this[0].instance_types, "")
}

output "distribution_configuration_name" {
  description = "Name of the distribution configuration"
  value       = try(aws_imagebuilder_distribution_configuration.this[0].name, "")
}

output "image_pipeline_name" {
  description = "Name of the image pipeline"
  value       = try(aws_imagebuilder_image_pipeline.this[0].name, "")
}

output "image_pipeline_arn" {
  description = "Arn of the image pipeline"
  value       = try(aws_imagebuilder_image_pipeline.this[0].arn, "")
}