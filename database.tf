
# Use of local for identifier causes recreation?
resource "aws_db_instance" "replica" {
  count    = "${var.enabled ? 1 : 0}"
  provider = "aws.replica"

  identifier          = "${local.name}"
  replicate_source_db = "${var.source_db_identifier}"
  instance_class      = "${var.instance_class}"

  db_subnet_group_name = "${aws_db_subnet_group.replica.name}"

  storage_type = "${var.storage_type}"
  iops         = "${var.storage_iops}"

  port                        = 5432
  # Alias causes a recreation on subsequent apply
  kms_key_id                  = "${data.aws_kms_alias.rds.arn}"
  storage_encrypted           = true
  publicly_accessible         = false
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = true

  tags = "${var.tags}"
}
