locals {
  component_external_arns = [for external_arn in var.component_external_arns : { name = split("/", external_arn)[1], arn = external_arn }]
}

resource "aws_imagebuilder_component" "this" {
  for_each = { for component in var.components : component.name => component }

  data                  = lookup(each.value, "data", null)
  uri                   = lookup(each.value, "uri", null)
  name                  = each.key
  description           = each.value.description
  version               = each.value.version
  platform              = lookup(each.value, "platform", "Linux")
  supported_os_versions = lookup(each.value, "supported_os_versions", null)
  kms_key_id            = lookup(each.value, "kms_key_id", null)
  tags                  = lookup(each.value, "tags", null)
}

resource "aws_imagebuilder_image_recipe" "this" {
  count = var.create_image_recipe ? 1 : 0

  name         = var.name
  parent_image = var.image_recipe_parent_image
  version      = var.image_recipe_version

  dynamic "block_device_mapping" {
    for_each = var.block_device_mapping
    content {
      device_name  = lookup(block_device_mapping.value, "device_name", null)
      no_device    = lookup(block_device_mapping.value, "no_device", null)
      virtual_name = lookup(block_device_mapping.value, "virtual_name", null)

      dynamic "ebs" {
        for_each = var.block_device_mapping

        content {
          delete_on_termination = lookup(block_device_mapping.value, "delete_on_termination", null)
          iops                  = lookup(block_device_mapping.value, "iops", null)
          volume_size           = lookup(block_device_mapping.value, "volume_size", null)
          volume_type           = lookup(block_device_mapping.value, "volume_type", null)
          encrypted             = lookup(block_device_mapping.value, "encrypted", null)
          kms_key_id            = lookup(block_device_mapping.value, "kms_key_id", null)
        }
      }
    }
  }

  dynamic "component" {
    for_each = { for component in concat(local.component_external_arns, var.components) : component.name => component }
    content {
      component_arn = try(aws_imagebuilder_component.this[component.value["name"]].arn, component.value["arn"])

      dynamic "parameter" {
        for_each = { for name, value in lookup(component.value, "parameters", {}) : name => value }
        content {
          name  = parameter.key
          value = parameter.value
        }
      }
    }
  }

  tags = merge({ "Name" = var.name }, var.tags)
}

resource "aws_imagebuilder_infrastructure_configuration" "this" {
  count = var.create_infrastructure_configuration ? 1 : 0

  name                          = var.name
  description                   = var.infrastructure_configuration_description
  instance_profile_name         = var.infrastructure_configuration_instance_profile_name
  instance_types                = var.infrastructure_configuration_instance_types
  key_pair                      = var.infrastructure_configuration_key_pair
  security_group_ids            = var.infrastructure_configuration_security_group_ids
  sns_topic_arn                 = var.infrastructure_configuration_sns_topic_arn
  subnet_id                     = var.infrastructure_configuration_subnet_id
  terminate_instance_on_failure = var.infrastructure_configuration_terminate_instance_on_failure

  dynamic "logging" {
    for_each = var.infrastructure_configuration_s3_logs_enabled ? [1] : []

    content {
      s3_logs {
        s3_bucket_name = var.infrastructure_configuration_s3_bucket_name
        s3_key_prefix  = var.infrastructure_configuration_s3_key_prefix
      }
    }
  }

  resource_tags = var.enable_resource_tags ? var.resource_tags : null
  tags          = merge({ "Name" = var.name }, var.tags)
}

resource "aws_imagebuilder_distribution_configuration" "this" {
  count = var.create_distribution_configuration ? 1 : 0

  name        = var.name
  description = var.distribution_configuration_description

  distribution {
    region = var.distribution_configuration_region

    dynamic "ami_distribution_configuration" {
      for_each = [var.ami_distribution_configuration]
      content {
        name               = "${lookup(ami_distribution_configuration.value, "name", null)}-{{ imagebuilder:buildDate }}"
        description        = lookup(ami_distribution_configuration.value, "description", null)
        kms_key_id         = lookup(ami_distribution_configuration.value, "kms_key_id", null)
        target_account_ids = try(ami_distribution_configuration.value["target_account_ids"], null)
        ami_tags           = lookup(ami_distribution_configuration.value, "ami_tags", {})

        dynamic "launch_permission" {
          for_each = var.ami_distribution_configuration != "" ? [var.launch_permission] : []
          content {
            organization_arns        = try(launch_permission.value["organization_arns"], [])
            organizational_unit_arns = try(launch_permission.value["organizational_unit_arns"], [])
            user_groups              = try(launch_permission.value["user_groups"], [])
            user_ids                 = try(launch_permission.value["user_ids"], [])
          }
        }
      }
    }

    dynamic "fast_launch_configuration" {
      for_each = var.fast_launch_configuration
      content {
        account_id            = lookup(fast_launch_configuration.value, "account_id", null)
        enabled               = lookup(fast_launch_configuration.value, "enabled", null)
        max_parallel_launches = lookup(fast_launch_configuration.value, "max_parallel_launches", null)

        dynamic "launch_template" {
          for_each = var.fast_launch_configuration != null ? [var.launch_template] : []
          content {
            launch_template_id      = try(launch_template.value["launch_template_id"], [])
            launch_template_name    = try(launch_template.value["launch_template_name"], [])
            launch_template_version = try(launch_template.value["launch_template_version"], [])
          }
        }
      }
    }

    dynamic "launch_template_configuration" {
      for_each = var.launch_template_configuration
      content {
        default            = try(launch_template_configuration.value["default"], null)
        account_id         = try(launch_template_configuration.value["account_id"], null)
        launch_template_id = try(launch_template_configuration.value["launch_template_id"], null)
      }
    }

  }

  tags = merge({ "Name" = var.name }, var.tags)
}

resource "aws_imagebuilder_image_pipeline" "this" {
  count = var.image_pipeline ? 1 : 0

  name                             = var.name
  description                      = var.image_pipeline_description
  enhanced_image_metadata_enabled  = var.image_pipeline_enhanced_image_metadata_enabled
  status                           = var.image_pipeline_status
  image_recipe_arn                 = var.image_recipe_arn != "" ? var.image_recipe_arn : aws_imagebuilder_image_recipe.this[0].arn
  infrastructure_configuration_arn = var.infrastructure_configuration_arn != "" ? var.infrastructure_configuration_arn : aws_imagebuilder_infrastructure_configuration.this[0].arn
  distribution_configuration_arn   = var.distribution_configuration_arn != "" ? var.distribution_configuration_arn : aws_imagebuilder_distribution_configuration.this[0].arn

  dynamic "image_tests_configuration" {
    for_each = var.image_tests_configuration
    content {
      image_tests_enabled = lookup(image_tests_configuration.value, "image_tests_enabled", null)
      timeout_minutes     = lookup(image_tests_configuration.value, "timeout_minutes", null)
    }
  }

  dynamic "schedule" {
    for_each = var.image_tests_configuration_schedule_enabled ? [1] : []

    content {
      schedule_expression = var.image_tests_configuration_schedule_expression
    }
  }

  tags = merge({ "Name" = var.name }, var.tags)
}