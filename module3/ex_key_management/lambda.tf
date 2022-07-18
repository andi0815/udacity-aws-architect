# This solution is based on: https://hands-on.cloud/how-to-manage-aws-lambda-using-terraform/#h-how-build-lambda-using-terraform

locals {
  resource_name_prefix         = "cand-c3-l3-ex2"
  lambda_code_path             = "lambda/"
  lambda_archive_path          = "cand-c3-l3-ex2-lambda.zip"
  lambda_handler_read          = "read_function.lambda_handler"
  lambda_handler_write         = "write_function.lambda_handler"
  lambda_description           = "Lambda function for cand-c3-l3-ex2"
  lambda_runtime               = "python3.9"
  lambda_timeout               = 1
  lambda_concurrent_executions = -1
  #lambda_cw_log_group_name     = "/aws/lambda/${aws_lambda_function.cand_c3_l3_ex2_lambda.function_name}"
  lambda_cw_log_group_name     = "/aws/lambda/cand_c3_l3_ex2_lambda"
  lambda_log_retention_in_days = 1
  common_tags = {
    env     = "dev"
    project = "udacity"
  }
}

data "archive_file" "cand_c3_l3_ex2_lambda_zip" {
  source_dir  = local.lambda_code_path
  output_path = local.lambda_archive_path
  type        = "zip"
}

# WRITE function
resource "aws_lambda_function" "cand_c3_l3_ex2_lambda_write" {
  function_name    = "${local.resource_name_prefix}-lambda-write"
  source_code_hash = data.archive_file.cand_c3_l3_ex2_lambda_zip.output_base64sha256
  filename         = data.archive_file.cand_c3_l3_ex2_lambda_zip.output_path
  description      = local.lambda_description
  role             = aws_iam_role.cand-c3-l3-ex2-write.arn
  handler          = local.lambda_handler_write
  runtime          = local.lambda_runtime
  timeout          = local.lambda_timeout

  tags = merge(
    {
      Name = "${local.resource_name_prefix}-lambda"
    },
    local.common_tags
  )

  reserved_concurrent_executions = local.lambda_concurrent_executions

  environment {
    variables = {
      S3_BUCKET = "cand-c3-l3-ex2-s3bucket"
      KEY_ARN   = aws_kms_key.cand-c3-l3-ex2-key.id
    }
  }
}

# READ function
resource "aws_lambda_function" "cand_c3_l3_ex2_lambda_read" {
  function_name    = "${local.resource_name_prefix}-lambda-read"
  source_code_hash = data.archive_file.cand_c3_l3_ex2_lambda_zip.output_base64sha256
  filename         = data.archive_file.cand_c3_l3_ex2_lambda_zip.output_path
  description      = local.lambda_description
  role             = aws_iam_role.cand-c3-l3-ex2-read.arn
  handler          = local.lambda_handler_read
  runtime          = local.lambda_runtime
  timeout          = local.lambda_timeout

  tags = merge(
    {
      Name = "${local.resource_name_prefix}-lambda"
    },
    local.common_tags
  )

  reserved_concurrent_executions = local.lambda_concurrent_executions

  environment {
    variables = {
      S3_BUCKET = "cand-c3-l3-ex2-s3bucket"
    }
  }
}

resource "aws_cloudwatch_log_group" "cand_c3_l3_ex2_lambda" {
  name              = local.lambda_cw_log_group_name
  retention_in_days = local.lambda_log_retention_in_days
}
