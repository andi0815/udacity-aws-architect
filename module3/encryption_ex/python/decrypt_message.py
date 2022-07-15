import os

def lambda_handler(event, context):
    return "[DECRYPT]: {} from Lambda!".format(event['message'])
