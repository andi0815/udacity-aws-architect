## Terraform Example incl. versioning and locking

The example works, but the main problem is, that at least the S3 Bucket has to be set up,
before the ```terraform.backend.s3``` can be set up.

Additionally, a ```terraform destroy``` will also destroy the S3 Bucket and DynamoDB. therefore
these resources should be managed in a separate terraform config.