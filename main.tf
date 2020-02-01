# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}

provider "archive" {}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

resource "aws_lambda_function" "lambda" {
  function_name = "terraform_lambda"

  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256

  role    = aws_iam_role.iam_for_lambda.arn
  handler = "terraform_lambda.lambda_handler"
  runtime = "python3.7"

  environment {
    variables = {
      greeting = "Hello terraform_lambda"
    }
  }
}