#environment variables 
variable "project_name" {
  description = "project name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

#s3 variables 
variable "web_file_bucket_name" {
  description = "s3 bucket name"
  type        = string
}