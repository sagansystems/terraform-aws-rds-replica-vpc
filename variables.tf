variable "enabled" {
  description = "If true a replica is created"
  default     = false
}

variable "region" {
  description = "Region to create the Replica in"
}

variable "aws_assume_role_profile" {
  description = "Profile to use when assuming an AWS role"
}

variable "aws_assume_role_arn" {
  description = "AWS role to assume"
}

variable "namespace" {
  description = "Namespace for the resources. ex: production1"
}

variable "source_db_identifier" {
  description = "Identifier of another Amazon RDS Database to replicate"
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
  default     = "io1"
}

variable "storage_iops" {
  description = "The amount of provisioned IOPS"
  default     = 1000
}

variable "cidr" {
  description = "CIDR Block for the VPC"
  default     = "10.22.0.0/16"
}

variable "subnets" {
  description = "Subnet to create for the instance"
  default     = ["10.22.1.0/24", "10.22.2.0/24", "10.22.3.0/24"]
}

variable "tags" {
  description = "Tags to assign to the resources"
  default     = {}
}
