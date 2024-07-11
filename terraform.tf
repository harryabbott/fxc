terraform {
  required_version = ">= 1.9.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.57.0"
    }
  }
  backend "s3" {
    bucket  = "harry-tf"
    key     = "state.tf"
    region  = "eu-west-2"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-west-2"
}