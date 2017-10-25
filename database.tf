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

module "vpc" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=tags/v1.0.4"

  name = "${var.namespace}-replica"
  cidr = "${var.cidr}"

  create_database_subnet_group = true
  database_subnets             = ["${var.subnet}"]
  azs                          = ["${data.aws_availability_zones.available.names[0]}"]

  tags = "${var.tags}"
}

resource "aws_db_instance" "replica" {
  replicate_source_db = "${var.source_db_identifier}"
  instance_class      = "${var.instance_class}"

  db_subnet_group_name   = "${module.vpc.database_subnet_group}"
  vpc_security_group_ids = ["${module.vpc.vpc_id}"]

  storage_type = "${var.storage_type}"
  iops         = "${var.storage_iops}"

  port                        = 5432
  storage_encrypted           = true
  publicly_accessible         = false
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = true

  tags = "${var.tags}"
}
