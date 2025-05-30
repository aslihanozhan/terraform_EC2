provider "aws" {
  region = "eu-north-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "myaslibucket"
}

terraform {
  backend "s3" {
    bucket         = "myaslibucket"
    key            = "terraform/terraform.tfstate"
    region         = "eu-north-1"
  }
}

