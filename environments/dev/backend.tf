
terraform {
  backend "s3" {
    bucket       = "jozzi-pizza-state-bucket"
    key          = "medallion-aws/dev/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}
