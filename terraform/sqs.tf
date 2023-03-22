resource "aws_sqs_queue" "application_queue" {
  name = "${var.environment}_application_queue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue.arn
    maxReceiveCount     = 3
  })

  tags = var.tags
}

resource "aws_sqs_queue" "dead_letter_queue" {
  name = "${var.environment}_dead_letter_queue"

  tags = var.tags
}