terraform {
  backend "s3" {
    bucket  = "my-terraform-state-bucket-7595e7a6" 
    key     = "terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}