output "vpc_id" {
  value = "module.vpc.vpc_id"
}

output "availability_zone" {
  value = "${aws_db_instance.replica.*.availability_zone}"
}

output "replica_arn" {
  value = "${aws_db_instance.replica.*.arn}"
}

output "replica_address" {
  value = "${aws_db_instance.replica.*.address}"
}

output "replica_endpoint" {
  value = "${aws_db_instance.replica.*.endpoint}"
}
