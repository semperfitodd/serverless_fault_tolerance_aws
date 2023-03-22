terraform {
  backend "s3" {
    bucket = "bsc.sandbox.terraform.state"
    key    = "serverless_fault_tolerance"
    region = "us-east-2"
  }
}