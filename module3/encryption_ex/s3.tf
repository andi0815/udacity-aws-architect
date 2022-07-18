# s3: bucket
resource "aws_s3_bucket" "encrypted_bucket" {
  bucket = "udacity-encrypted-bucket"
}

# s3 encryption: terraform bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_s3_encryption" {
  bucket = aws_s3_bucket.encrypted_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      #   kms_master_key_id = aws_kms_key.terraform_key.arn
      sse_algorithm = "aws:kms"
    }
  }
}

# # s3 encryption key
# resource "aws_kms_key" "terraform_key" {
#   description             = "This key is used to encrypt the terraform bucket"
#   deletion_window_in_days = 10
# }

# Add IAM Policy
resource "aws_iam_policy" "iam_policy_for_s3" {
  name        = "udacity_s3_policy"
  path        = "/"
  description = "AWS IAM Policy for accessing encrypted s3 bucket."
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : ["s3:ListBucket"],
        "Resource" : ["arn:aws:s3:::udacity-encrypted-bucket"]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        "Resource" : ["arn:aws:s3:::udacity-encrypted-bucket/*"]
      }
    ]
  })
}
