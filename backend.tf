# store the tf state file in s3 and lock with dynamodb 
terraform {
  backend "s3" {
    bucket         = "cloud-resume-tfstate"
    key            = "crc/terraform.tfstate"
    region         = "us-east-1"
    profile        = "terraform-user"
    dynamodb_table = "terraform-state-lock"
  }
}
