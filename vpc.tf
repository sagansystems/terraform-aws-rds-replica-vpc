module "vpc_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "vpc"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_vpc" "replica" {
  count    = "${var.enabled ? 1 : 0}"
  provider = "aws.replica"

  cidr_block = "${var.cidr}"

  tags = "${module.vpc_label.tags}"
}

module "ubnet_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "subnet"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_subnet" "replica" {
  count    = "${var.enabled ? length(var.subnets) : 0}"
  provider = "aws.replica"

  vpc_id                  = "${aws_vpc.replica.id}"
  cidr_block              = "${element(var.subnets, count.index)}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = false

  tags = "${module.db_subnet_label.tags}"
}

module "db_subnet_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "db-subnet"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_db_subnet_group" "replica" {
  count    = "${var.enabled ? 1 : 0}"
  provider = "aws.replica"

  name        = "${module.db_subnet_label.id}"
  description = "Database subnet group for ${module.db_subnet_label.name}"
  subnet_ids  = ["${aws_subnet.replica.*.id}"]

  tags = "${module.db_subnet_label.tags}"
}
