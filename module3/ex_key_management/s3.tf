# s3: bucket
resource "aws_s3_bucket" "cand-c3-l3-ex2-s3bucket" {
  bucket = "cand-c3-l3-ex2-s3bucket"
  # allow deletion of a non-empty bucket
  force_destroy = true
  lifecycle {
    prevent_destroy = false
  }
}
