module "db_subnet_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "db-subnet"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_db_subnet_group" "replica" {
  count = "${var.enabled == "true" ? 1 : 0}"

  name        = "${module.db_subnet_label.id}"
  description = "Database subnet group for ${module.db_subnet_label.name}"
  subnet_ids  = ["${aws_subnet.zone_1.id}", "${aws_subnet.zone_2.id}", "${aws_subnet.zone_3.id}"]

  tags = "${module.db_subnet_label.tags}"
}

module "kms_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "kms"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_kms_key" "repica" {
  count = "${var.enabled == "true" ? 1 : 0}"

  description             = "${module.kms_label.id} key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  tags                    = "${module.kms_label.tags}"
}

module "rds_label" {
  enabled    = "${var.enabled}"
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.3"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "rds"
  attributes = ["replica"]
  tags       = "${var.tags}"
}

resource "aws_db_instance" "replica" {
  count = "${var.enabled == "true" ? 1 : 0}"

  identifier          = "${module.rds_label.id}"
  replicate_source_db = "${var.source_db_identifier}"
  instance_class      = "${var.instance_class}"

  db_subnet_group_name = "${aws_db_subnet_group.replica.name}"

  storage_type = "${var.storage_type}"
  iops         = "${var.storage_iops}"

  monitoring_interval = "${var.monitoring_interval}"

  port                        = 5432
  kms_key_id                  = "${aws_kms_key.repica.arn}"
  storage_encrypted           = true
  publicly_accessible         = false
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = true
  skip_final_snapshot         = true

  tags = "${module.rds_label.tags}"
}
