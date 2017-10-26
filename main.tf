terraform {
  required_version = ">= 0.10.0"
}

provider "aws" {
  alias   = "replica"
  region  = "${var.region}"

  profile = "${var.aws_assume_role_profile}"
  assume_role {
    role_arn = "${var.aws_assume_role_arn}"
  }
}

data "aws_availability_zones" "available" {
  provider = "aws.replica"
  state    = "available"
}
