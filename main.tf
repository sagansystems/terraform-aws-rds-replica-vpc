terraform {
  required_version = ">= 0.11.0"
}

data "aws_availability_zones" "available" {
  state = "available"
}
