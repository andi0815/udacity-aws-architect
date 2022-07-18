# ##################################
# Role 1: Write access
# ##################################

# Add IAM write role for lambda functions
resource "aws_iam_role" "cand-c3-l3-ex2-write" {
  name = "cand-c3-l3-ex2-write"
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
    env = "dev"
  }
}

# Attach AWSLambdaExecute Policy to cand-c3-l3-ex2-write
resource "aws_iam_role_policy_attachment" "attach_execute_lambda_policy_to_iam_write_role" {
  role       = aws_iam_role.cand-c3-l3-ex2-write.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

# Attach AmazonS3FullAccess Policy to cand-c3-l3-ex2-write
resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_iam_lambda_write_role" {
  role       = aws_iam_role.cand-c3-l3-ex2-write.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# ##################################
# Role 2: Read access
# ##################################
# Add IAM read role for lambda functions
resource "aws_iam_role" "cand-c3-l3-ex2-read" {
  name = "cand-c3-l3-ex2-read"
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
    env = "dev"
  }
}

# Attach AWSLambdaExecute Policy to cand-c3-l3-ex2-read
resource "aws_iam_role_policy_attachment" "attach_execute_lambda_policy_to_iam_read_role" {
  role       = aws_iam_role.cand-c3-l3-ex2-read.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

# Attach AmazonS3ReadOnlyAccess Policy to cand-c3-l3-ex2-read
resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_iam_lambda_read_role" {
  role       = aws_iam_role.cand-c3-l3-ex2-read.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# ##################################
# KMS Key:
# ##################################

resource "aws_kms_key" "cand-c3-l3-ex2-key" {
  description             = "KMS for cand-l3-ex2"
  deletion_window_in_days = 10
  policy = jsonencode(
    {
      "Id" : "cand-c3-l3-ex2-key-policy",
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Enable my IAM User to administer this key",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::697203805168:root"
          },
          "Action" : "kms:*",
          "Resource" : "*"
        },
        {
          "Sid" : "Allow access for Key Administrators",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::697203805168:role/voclabs"
          },
          "Action" : [
            "kms:Create*",
            "kms:Describe*",
            "kms:Enable*",
            "kms:List*",
            "kms:Put*",
            "kms:Update*",
            "kms:Revoke*",
            "kms:Disable*",
            "kms:Get*",
            "kms:Delete*",
            "kms:TagResource",
            "kms:UntagResource",
            "kms:ScheduleKeyDeletion",
            "kms:CancelKeyDeletion"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "Allow use of the key",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::697203805168:role/cand-c3-l3-ex2-write"
          },
          "Action" : [
            "kms:Encrypt",
            "kms:Decrypt",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:DescribeKey"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "Allow use of the key for decryption, only",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::697203805168:role/cand-c3-l3-ex2-read"
          },
          "Action" : [
            "kms:Decrypt",
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "Allow attachment of persistent resources",
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : "arn:aws:iam::697203805168:role/cand-c3-l3-ex2-write"
          },
          "Action" : [
            "kms:CreateGrant",
            "kms:ListGrants",
            "kms:RevokeGrant"
          ],
          "Resource" : "*",
          "Condition" : {
            "Bool" : {
              "kms:GrantIsForAWSResource" : "true"
            }
          }
        }
      ]
    }
  )
}
