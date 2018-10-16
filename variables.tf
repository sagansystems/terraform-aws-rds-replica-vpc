variable "enabled" {
  description = "Set to true to enable the module"
  default     = "true"
}

variable "namespace" {
  description = "Namespace for the resources. ex: production1"
}

variable "stage" {
  description = "Stage of the replica (prod/staging/dev)"
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

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60"
  default     = "0"
}

variable "cidr" {
  description = "CIDR Block for the VPC"
  default     = "10.22.0.0/16"
}

variable "tags" {
  description = "Tags to assign to the resources"
  default     = {}
}

variable "monitoring_role_arn" {
  description = "role to enalbe enhanced monitoring"
  default     = ""
}