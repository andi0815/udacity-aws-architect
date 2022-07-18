import boto3

FILE_NAME = "message.txt"
BUCKET_NAME = "udacity-encrypted-bucket"

def lambda_handler(event, context):
    s3 = boto3.resource("s3")
    object = s3.Object(BUCKET_NAME,FILE_NAME)

    return f"Got '{object.get()['Body'].read()}' from: 'S3://{FILE_NAME}'"
