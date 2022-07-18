# Create a zip of the lambda function
data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/lambda.zip"
}

# Add lambda function
resource "aws_lambda_function" "udacity_lambda_encrypt" {
  filename      = "${path.module}/lambda.zip"
  function_name = "encrypt_data"
  role          = aws_iam_role.lambda_role.arn
  handler       = "encrypt_message.lambda_handler"
  runtime       = "python3.8"
}

# Add lambda function
resource "aws_lambda_function" "udacity_lambda_decrypt" {
  filename      = "${path.module}/lambda.zip"
  function_name = "decrypt_data"
  role          = aws_iam_role.lambda_role.arn
  handler       = "decrypt_message.lambda_handler"
  runtime       = "python3.8"
}

# Add IAM Role
resource "aws_iam_role" "lambda_role" {
  name = "udacity_lambda_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
  tags = {
    Name = "AllowLogCreation"
  }
}

# Add IAM Policy
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "udacity_lambda_iam_policy"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*",
        "Effect" : "Allow"
      }
    ]
  })
}

# Attach lambda IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_lambda_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}

# Attach S3 IAM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_iam_lambda_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_s3.arn
}
