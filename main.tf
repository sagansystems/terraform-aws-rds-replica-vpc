terraform {
  required_version = ">= 0.10.0"
}

provider "aws" {
  region  = "${var.region}"
  alias   = "replica"
  profile = "${var.aws_assume_role_profile}"

  assume_role {
    role_arn = "${var.aws_assume_role_arn}"
  }
}

data "aws_availability_zones" "available" {
  provider = "aws.replica"
  state    = "available"
}

locals {
  name              = "${var.namespace}-replica"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
