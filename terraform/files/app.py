import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    try:
        # Parse input and validate format
        body = json.loads(event['Records'][0]['body'])
        if 'number' not in body:
            raise ValueError('Invalid input format')

        number = int(body['number'])
        if number <= 0:
            raise ValueError('Number must be positive and non-zero')

        logger.info(f"Received message: {body}")
        logger.info(f"Number: {number}")

        # Calculate square of number
        result = number ** 2

        logger.info(f"Square of {number} is {result}")

        # Return result if successful
        return {
            'statusCode': 200,
            'body': json.dumps({'result': result})
        }

    except (ValueError, KeyError, TypeError) as e:
        logger.error(f"Error processing message: {e}")
        # Return error response if input is invalid
        return {
            'statusCode': 400,
            'body': json.dumps({'error': str(e)})
        }
