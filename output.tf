output "vpc_id" {
  value = "module.vpc.vpc_id"
}

output "availability_zone" {
  value = "${join("", aws_db_instance.replica.*.availability_zone)}"
}

output "replica_arn" {
  value = "${join("", aws_db_instance.replica.*.arn)}"
}

output "replica_address" {
  value = "${join("", aws_db_instance.replica.*.address)}"
}

output "replica_endpoint" {
  value = "${join("", aws_db_instance.replica.*.endpoint)}"
}
