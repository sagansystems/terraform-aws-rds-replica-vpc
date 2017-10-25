provider "aws" {
  region = "${var.region}"
  alias  = "replica"
}

data "aws_availability_zones" "available" {
  provider = "aws.replica"
  state    = "available"
}

module "vpc" {
  source = "git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=tags/v1.0.4"

  name = "${var.namespace}-replica"
  cidr = "${var.cidr}"

  create_database_subnet_group = true
  database_subnets             = "[${var.subnet}]"
  azs                          = "[${data.aws_availability_zones.available.names[0]}]"

  tags = "${var.tags}"
}

# resource "aws_db_instance" "replica" {
#   replicate_source_db         = "${var.replicate_source_db}"       
#   instance_class              = "${var.db_instance_class}"         
#   publicly_accessible         = false                              
#   auto_minor_version_upgrade  = true                               
#   allow_major_version_upgrade = true                               
#   db_subnet_group_name        = "${aws_db_subnet_group.default.id}"


#   storage_type      = "${var.db_instance_storage_type}"            
#   iops              = "${var.db_instance_storage_iops}"            
#   storage_encrypted = true                                         


#   port = 5432                                                                                      


#   vpc_security_group_ids = ["${aws_security_group.default.id}"]    


#   tags = "${var.tags}"
# }  

