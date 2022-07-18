import boto3

FILE_NAME = "message.txt"
BUCKET_NAME = "udacity-encrypted-bucket"

def lambda_handler(event, context):
    message = "[ENCRYPTED]: {} from Lambda!".format(event['message'])
    encoded_string = message.encode("utf-8")

    s3 = boto3.resource("s3")
    s3.Bucket(BUCKET_NAME).put_object(Key=FILE_NAME, Body=encoded_string)

    return f"Wrote '{message}' to: 'S3://{FILE_NAME}'"
