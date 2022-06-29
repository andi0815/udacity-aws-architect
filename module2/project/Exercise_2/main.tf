provider "aws" {
  # Credentials are stored in: ~/.aws/credentials
  access_key = ""
  secret_key = ""
  token = ""
  region = var.region
}

# Create a zip of the lambda function
data "archive_file" "zip_the_python_code" {
    type        = "zip"
    source_dir  = "${path.module}/python/"
    output_path = "${path.module}/lambda.zip"
}

# Add lambda function
resource "aws_lambda_function" "udacity_lambda" {
  filename      = "${path.module}/lambda.zip"
  function_name = "greetings"
  role          = aws_iam_role.lambda_role.arn
  handler       = "greet_lambda.lambda_handler"
  runtime       = "python3.8"
  environment {
    variables = {
      greeting = "Goodbye"
    }
  }
}

# Add IAM Role
resource "aws_iam_role" "lambda_role" {
  name                  = "udacity_lambda_role"
  assume_role_policy    = jsonencode({
                            "Version": "2012-10-17",
                            "Statement": [
                                {
                                    "Action": "sts:AssumeRole",
                                    "Principal": {
                                    "Service": "lambda.amazonaws.com"
                                    },
                                    "Effect": "Allow",
                                    "Sid": ""
                                }
                            ]
                          })
  tags                  = {
    Name = "AllowLogCreation"
  }
}

# Add IAM Policy
resource "aws_iam_policy" "iam_policy_for_lambda" {
 name         = "udacity_lambda_iam_policy"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = jsonencode({
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Action": [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                    ],
                    "Resource": "arn:aws:logs:*:*:*",
                    "Effect": "Allow"
                }
            ]
          })
}

# Attach IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_lambda_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}
