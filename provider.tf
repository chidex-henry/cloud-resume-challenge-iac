# configure the AWS Provider 
provider "aws" {
  region  = "us-east-1"
  profile = "terraform-user"

  default_tags {
    tags = {
      "Automation"  = "terraform"
      "Porject"     = var.project_name
      "Environment" = var.environment
    }
  }
}