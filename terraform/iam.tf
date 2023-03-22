data "aws_iam_policy" "AmazonSQSFullAccess" {
  name = "AmazonSQSFullAccess"
}

data "aws_iam_policy" "AWSLambdaBasicExecutionRole" {
  name = "AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "api_gw_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["apigateway.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "lambda_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "api_gw_execution_role" {
  name = "${var.environment}_api_gw_execution_role"

  assume_role_policy = data.aws_iam_policy_document.api_gw_execution_role.json

  tags = var.tags
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.environment}_lambda_execution_role"

  assume_role_policy = data.aws_iam_policy_document.lambda_execution_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "AmazonSQSFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  role       = aws_iam_role.api_gw_execution_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  policy_arn = data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_iam_role_policy_attachment" "lambda_sqs_policy" {
  policy_arn = data.aws_iam_policy.AmazonSQSFullAccess.arn
  role       = aws_iam_role.lambda_execution_role.name
}