module "vpc_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=fix-tags"
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
  zone_1_az = "${element(data.aws_availability_zones.available.names, 0)}"
  zone_2_az = "${element(data.aws_availability_zones.available.names, 1)}"
  zone_3_az = "${element(data.aws_availability_zones.available.names, 2)}"
}

module "zone_1_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=fix-tags"
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
  cidr_block        = "${cidrsubnet(aws_vpc.replica.cidr_block, 2, 0)}"

  tags = "${module.zone_1_label.tags}"
}

module "zone_2_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=fix-tags"
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
  cidr_block        = "${cidrsubnet(aws_vpc.replica.cidr_block, 2, 1)}"

  tags = "${module.zone_2_label.tags}"
}

module "zone_3_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=fix-tags"
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
  cidr_block        = "${cidrsubnet(aws_vpc.replica.cidr_block, 2, 2)}"

  tags = "${module.zone_3_label.tags}"
}
