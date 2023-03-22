# serverless_fault_tolerance_poc

## Use TerraForm to build the following:
* Lambda functions
* API Gateway
* API Gateway resources
* API Gateway deployments
* SQS queues
* IAM policies and roles
## Set variables in variables.tf
* my_name
* tags
## Set backend
* give valid S3 bucket and key where you want your state held
## Run Terraform
```
terraform init
terraform validate
terraform plan -out=plan.out
terraform apply plan.out
```
## Test Lambda by adding to the SQS queue with the CLI
```
aws sqs \
  --region <REGION> send-message \
  --queue-url <SQS_URL> \
  --message-body '{"number": <ANY_NUMBER>}'
```
## Test API Gateway > Lambda > SQS > Lambda

curl -X POST -H "Content-Type: application/json" -d \
  '{"number": <ANY_NUMBER>}' \
  <API_URL>
## Check output in CloudWatch Logs
* Find log group based off SQS Lambda function name
* Expand [INFO]
![cloudwatch.png](files%2Fcloudwatch.png)
## Clean up Terraform
```
terraform destroy
```