terraform {
    backend "s3" {
        bucket = "terraform-s3-backend-bucket-2"
        key = "terraform.tfstate"
        region = "us-east-2"
        dynamodb_table = "terraform-s3-backend-locking-db"
    }
}

# dynamo db: locking table
resource "aws_dynamodb_table" "tf_remote_state_locking" {
  hash_key = "LockID"
  name = "terraform-s3-backend-locking-db"
  attribute {
    name = "LockID"
    type = "S"
  }
  billing_mode = "PAY_PER_REQUEST"
}

# s3: terraform state bucket
resource "aws_s3_bucket" "tf_remote_state_2" {
  bucket = "terraform-s3-backend-bucket-2"
#   lifecycle {
#     prevent_destroy = true
#   }
}

# s3 bucket versioning
resource "aws_s3_bucket_versioning" "tf_remote_state_versioning" {
  bucket = aws_s3_bucket.tf_remote_state_2.id
  versioning_configuration {
    status = "Enabled"
  }
}

# s3 encryption: terraform bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_s3_encryption" {
  bucket = aws_s3_bucket.tf_remote_state_2.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# s3 encryption key
resource "aws_kms_key" "terraform_key" {
  description             = "This key is used to encrypt the terraform bucket"
  deletion_window_in_days = 10
}
