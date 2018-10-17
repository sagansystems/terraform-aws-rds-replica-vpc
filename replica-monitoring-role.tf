# RDS Enhanced monitroing role
resource "aws_iam_role" "rds_monitoring_role" {
  count = "${var.monitoring_interval > 0 ? 1 : 0}"

  name = "${var.cluster}-enhanced-monitoring-role"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = "${data.aws_iam_policy_document.rds_monitoring_assume_role.json}"
}

data "aws_iam_policy_document" "rds_monitoring_assume_role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }

    effect = "Allow"
  }
}

resource "aws_iam_policy" "rds_monitoring_policy" {
  count = "${var.monitoring_interval > 0 ? 1 : 0}"
  
  name = "${var.cluster}-enhanced-monitoring-policy"
  
  policy = "${data.aws_iam_policy_document.rds_monitoring_policy_document.json}"

}

data "aws_iam_policy_document" "rds_monitoring_policy_document" {
  statement {
    sid = "EnableCreationAndManagementOfRDSCloudwatchLogGroups"

    actions = [
      "logs:CreateLogGroup",
      "logs:PutRetentionPolicy"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:log-group:RDS*"
    ]
  }

  statement {
    sid = "EnableCreationAndManagementOfRDSCloudwatchLogStreams"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:GetLogEvents"
    ]

    effect = "Allow"

    resources = [
      "arn:aws:logs:*:*:log-group:RDS*:log-stream:*"
    ]
  }
}

resource "aws_iam_policy_attachment" "role_policy_attachment" {
  count = "${var.monitoring_interval > 0 ? 1 : 0}"

  name       = "${var.cluster}-role-policy-attachment"
  roles      = ["${aws_iam_role.rds_monitoring_role.name}"]
  policy_arn = "${aws_iam_policy.rds_monitoring_policy.arn}"

  lifecycle {
    create_before_destroy = true
  }
}
