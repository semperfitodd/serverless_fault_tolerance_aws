data "archive_file" "api" {
  source_file = "${path.module}/files/api.py"
  output_path = "api.zip"
  type        = "zip"
}

data "archive_file" "sqs" {
  source_file = "${path.module}/files/app.py"
  output_path = "app.zip"
  type        = "zip"
}

resource "aws_lambda_event_source_mapping" "sqs_polling" {
  event_source_arn = aws_sqs_queue.application_queue.arn
  function_name    = aws_lambda_function.sqs.arn
  batch_size       = 1
}

resource "aws_lambda_function" "api" {
  filename      = "api.zip"
  function_name = "${var.environment}_api"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "api.lambda_handler"
  runtime       = "python3.9"
  timeout       = 60

  environment {
    variables = {
      SQS_URL = aws_sqs_queue.application_queue.url
    }
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.dead_letter_queue.arn
  }

  source_code_hash = data.archive_file.api.output_base64sha256

  tags = var.tags
}

resource "aws_lambda_function" "sqs" {
  filename      = "app.zip"
  function_name = "${var.environment}_sqs"
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "app.lambda_handler"
  runtime       = "python3.9"

  environment {
    variables = {
      SQS_URL = aws_sqs_queue.application_queue.url
    }
  }

  dead_letter_config {
    target_arn = aws_sqs_queue.dead_letter_queue.arn
  }

  source_code_hash = data.archive_file.sqs.output_base64sha256

  tags = var.tags
}