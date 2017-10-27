module "kms_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "kms"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_kms_key" "repica" {
  count    = "${var.enabled ? 1 : 0}"
  provider = "aws.replica"

  description             = "${module.kms_label.id} key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags = "${module.kms_label.tags}"
}

module "rds_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.2"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "rds"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_db_instance" "replica" {
  count    = "${var.enabled ? 1 : 0}"
  provider = "aws.replica"

  identifier          = "${module.rds_label.name}"
  replicate_source_db = "${var.source_db_identifier}"
  instance_class      = "${var.instance_class}"

  db_subnet_group_name = "${aws_db_subnet_group.replica.name}"

  storage_type = "${var.storage_type}"
  iops         = "${var.storage_iops}"

  port                        = 5432
  kms_key_id                  = "${aws_kms_key.repica.arn}"
  storage_encrypted           = true
  publicly_accessible         = false
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = true

  tags = "${module.rds_label.tags}"
}
