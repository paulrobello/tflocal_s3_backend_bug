terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.20.0"
    }
  }
  backend "s3" {
    region  = "us-east-1"
    bucket  = "iac-state-us-east-1"
    key     = "global-iac/project/lcl/terraform.tfstate"
    encrypt = true
  }
}

variable "aws_region_primary" {
  default = "us-east-1"
}

provider "aws" {
  region = var.aws_region_primary
}

resource "aws_dynamodb_table" "jobs" {
  name           = "jobs"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "pk"
  range_key      = "rk"
  read_capacity  = 0
  write_capacity = 0
  point_in_time_recovery {
    enabled = true
  }
  ttl {
    enabled        = true
    attribute_name = "expires_at"
  }
  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "rk"
    type = "S"
  }
}

resource "aws_iam_policy" "ddb_lambda_policy" {
  name        = "ddb-lambda_plcy"
  description = "Policy to allow Lambda access to DDB"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
        ],
        Effect   = "Allow",
        Resource = aws_dynamodb_table.jobs.arn
      }
    ]
  })
}

output "ddb_table_name" {
  value = aws_dynamodb_table.jobs.name
}
