output "website_url" {
  description = "my website url"
  value = aws_s3_bucket_website_configuration.web-config.website_endpoint
}

output "function_name" {
  description = "Name of the Lambda function."
  value = aws_lambda_function.resume_lambda.function_name
}

