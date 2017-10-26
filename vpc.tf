locals {
  name              = "${var.namespace}-replica"
}

resource "aws_vpc" "replica" {
  count    = "${var.enabled ? 1 : 0}"
  provider = "aws.replica"

  cidr_block = "${var.cidr}"

  tags = "${merge(var.tags, map("Name", format("%s", local.name)))}"
}

resource "aws_subnet" "replica" {
  count    = "${var.enabled ? length(var.subnets) : 0}"
  provider = "aws.replica"

  vpc_id            = "${aws_vpc.replica.id}"
  cidr_block        = "${element(subnets, count.index)}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = "${merge(var.tags, map("Name", format("%s", local.name)))}"
}

resource "aws_db_subnet_group" "replica" {
  count    = "${var.enabled ? 1 : 0}"
  provider = "aws.replica"

  name        = "${local.name}"
  description = "Database subnet group for ${local.name}"
  subnet_ids  = ["${aws_subnet.replica.*.id}"]

  tags = "${merge(var.tags, map("Name", format("%s", local.name)))}"
}
