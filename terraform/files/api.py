import json
import boto3
import os

sqs = boto3.client('sqs')
queue_url = os.environ['SQS_URL']


def lambda_handler(event, context):
    try:
        if 'body' in event:
            event = json.loads(event['body'])

        number = event['number']
        response = sqs.send_message(
            QueueUrl=queue_url,
            MessageBody=json.dumps({'number': number})
        )
        return {
            'statusCode': 200,
            'body': json.dumps({'message': 'Number received'})
        }

    except (ValueError, KeyError, TypeError) as e:
        return {
            'statusCode': 400,
            'body': json.dumps({'error': str(e)})
        }
