import os

def lambda_handler(event, context):
    return "[ENCRYPT]: {} from Lambda!".format(event['message'])
