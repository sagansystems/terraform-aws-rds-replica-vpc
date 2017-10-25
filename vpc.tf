resource "aws_vpc" "replica" {
  count = "${var.enabled ? 1 : 0}"

  cidr_block = "${var.cidr}"

  tags = "${merge(var.tags, map("Name", format("%s", local.name)))}"
}

resource "aws_subnet" "replica" {
  count = "${var.enabled ? 1 : 0}"

  vpc_id            = "${aws_vpc.replica.id}"
  cidr_block        = "${var.subnet}"
  availability_zone = "${local.availability_zone}"

  tags = "${merge(var.tags, map("Name", format("%s", local.name)))}"
}

resource "aws_db_subnet_group" "replica" {
  count = "${var.enabled ? 1 : 0}"

  name        = "${local.name}"
  description = "Database subnet group for ${local.name}"
  subnet_ids  = ["${aws_subnet.replica.*.id}"]

  tags = "${merge(var.tags, map("Name", format("%s", local.name)))}"
}
