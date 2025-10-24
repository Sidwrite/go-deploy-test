terraform {
  backend "s3" {
    bucket = "new-project-terraform-state-211125755493"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
