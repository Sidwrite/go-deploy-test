terraform {
  backend "s3" {
    bucket = "go-app-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
