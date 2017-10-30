module "vpc_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.0"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "vpc"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_vpc" "replica" {
  count    = "${var.enabled == "true" ? 1 : 0}"
  provider = "aws.replica"

  cidr_block = "${var.cidr}"

  tags = "${module.vpc_label.tags}"
}

locals {
  zone_1_az                 = "${element(data.aws_availability_zones.available.names, 0)}"
  zone_1_private_cidr_block = "${cidrsubnet(aws_vpc.replica.cidr_block, 2, 0)}"

  zone_2_az                 = "${element(data.aws_availability_zones.available.names, 1)}"
  zone_2_private_cidr_block = "${cidrsubnet(aws_vpc.replica.cidr_block, 2, 1)}"

  zone_3_az                 = "${element(data.aws_availability_zones.available.names, 2)}"
  zone_3_private_cidr_block = "${cidrsubnet(aws_vpc.replica.cidr_block, 2, 2)}"
}

module "zone_1_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.0"
  namespace  = "${var.namespace}"
  name       = "${local.zone_1_az}"
  attributes = ["private"]
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_subnet" "zone_1" {
  count             = "${var.enabled == "true" ? 1 : 0}"
  provider          = "aws.replica"
  vpc_id            = "${aws_vpc.replica.id}"
  availability_zone = "${local.zone_1_az}"
  cidr_block        = "${local.zone_1_private_cidr_block}"

  tags = "${module.zone_1_label.tags}"
}

module "zone_2_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.0"
  namespace  = "${var.namespace}"
  name       = "${local.zone_2_az}"
  attributes = ["private"]
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_subnet" "zone_2" {
  count             = "${var.enabled == "true" ? 1 : 0}"
  provider          = "aws.replica"
  vpc_id            = "${aws_vpc.replica.id}"
  availability_zone = "${local.zone_2_az}"
  cidr_block        = "${local.zone_2_private_cidr_block}"

  tags = "${module.zone_2_label.tags}"
}

module "zone_3_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.0"
  namespace  = "${var.namespace}"
  name       = "${local.zone_3_az}"
  attributes = ["private"]
  stage      = "${var.stage}"
  tags       = "${var.tags}"
}

resource "aws_subnet" "zone_3" {
  count             = "${var.enabled == "true" ? 1 : 0}"
  provider          = "aws.replica"
  vpc_id            = "${aws_vpc.replica.id}"
  availability_zone = "${local.zone_3_az}"
  cidr_block        = "${local.zone_3_private_cidr_block}"

  tags = "${module.zone_3_label.tags}"
}

module "db_subnet_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.0"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "db-subnet"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_db_subnet_group" "replica" {
  count    = "${var.enabled == "true" ? 1 : 0}"
  provider = "aws.replica"

  name        = "${module.db_subnet_label.id}"
  description = "Database subnet group for ${module.db_subnet_label.name}"
  subnet_ids  = ["${aws_subnet.zone_1.id}", "${aws_subnet.zone_2.id}", "${aws_subnet.zone_1.id}"]

  tags = "${module.db_subnet_label.tags}"
}
