terraform {
  backend "s3" {
    bucket = "terraform-eryani-learning"
    key    = "apiGateway-aaignment"
    region = "us-east-1"
  }
}
