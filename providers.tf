terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.84.0"
    }
  }
}

provider "aws" {
    profile                     = terraform.workspace
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
}
