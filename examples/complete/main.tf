################################################################################
# Role IAM for EC2-Image-Builder Module
################################################################################
resource "aws_iam_role" "iam_role" {
  name = var.name
  path = "/${var.name}/"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "istance_profile" {
  name = var.name
  role = aws_iam_role.iam_role.name
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.iam_role.id
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/EC2InstanceProfileForImageBuilder"
}

################################################################################
# S3 Bucket for logs
################################################################################
resource "aws_s3_bucket" "bucket_logs" {
  bucket = "${var.account_id}-${var.name}-s3"

}

resource "aws_s3_bucket_public_access_block" "bucket_logs" {
  bucket = aws_s3_bucket.bucket_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket.bucket_logs
  ]
}

resource "aws_s3_bucket_acl" "bucket_logs" {
  bucket = aws_s3_bucket.bucket_logs.id
  acl    = "private"
}

################################################################################
# EC2-Image-Builder Module
################################################################################
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