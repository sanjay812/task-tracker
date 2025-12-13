terraform {
  backend "s3" {
    bucket         = "terraform-state-17014c2b"
    key            = "test/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock-17014c2b"
    encrypt        = true
  }
}
