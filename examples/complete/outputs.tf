output "component" {
  description = "Map of Component"
  value       = module.imagebuilder.component
}

output "component_name" {
  description = "List of Name of the component"
  value       = module.imagebuilder.component_name
}

output "component_arn" {
  description = "List of Arn of the component"
  value       = module.imagebuilder.component_arn
}

output "image_recipe_arn" {
  description = "Amazon Resource Name (ARN) of the image recipe"
  value       = module.imagebuilder.image_recipe_arn
}

output "infrastructure_configuration_arn" {
  description = "arn of the infrastructure configuration"
  value       = module.imagebuilder.infrastructure_configuration_arn
}

output "distribution_configuration_name" {
  description = "Name of the distribution configuration"
  value       = module.imagebuilder.distribution_configuration_name
}

output "image_pipeline_arn" {
  description = "Name of the distribution configuration"
  value       = module.imagebuilder.image_pipeline_arn
}