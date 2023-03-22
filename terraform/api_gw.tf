resource "aws_api_gateway_deployment" "apigw_lambda" {
  depends_on = [
    aws_api_gateway_integration.api_step,
    #    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "test"
}

#resource "aws_api_gateway_integration" "lambda" {
#  rest_api_id = aws_api_gateway_rest_api.this.id
#  resource_id = aws_api_gateway_method.proxy.resource_id
#  http_method = aws_api_gateway_method.proxy.http_method
#
#  integration_http_method = "POST"
#  type                    = "AWS_PROXY"
#  uri                     = aws_lambda_function.this.invoke_arn
#}

resource "aws_api_gateway_integration" "api_step" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_root.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.api.invoke_arn
  credentials             = aws_iam_role.api_gw_execution_role.arn

  request_templates = {
    "application/json" = "{ \"body\": $input.json('$') }"
  }

  passthrough_behavior = "WHEN_NO_TEMPLATES"
}




resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.api.invoke_arn
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_rest_api.this.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_rest_api" "this" {
  name        = var.environment
  description = "${var.environment} rest api gateway"

  tags = var.tags
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}
