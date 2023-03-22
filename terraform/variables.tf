variable "aws_region" {
  description = "AWS Region to deploy resources"
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name we are building"
  default     = "serverless_fault_tolerance_poc"
}

variable "my_name" {
  description = "My name"
  default     = "Todd Bernson"
}

variable "tags" {
  description = "Default tags for this environment"
  default     = {}
}