resource "aws_iam_policy" "policy" {
  name        = "cand-c3-l4-e1-iam-policy"
  path          = "/"
  description = "a policy to test IAC scanning"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}