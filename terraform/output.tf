output "api_gateway_lambda_base_url" {
  value = aws_api_gateway_deployment.apigw_lambda.invoke_url
}

output "sqs_queue_url" {
  value = aws_sqs_queue.application_queue.url
}