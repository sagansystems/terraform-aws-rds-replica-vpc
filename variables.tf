variable "provider_alias" {
}

variable "region" {
  description = "Region to create the Replica in"
}

variable "namespace" {
  description = "Namespace for the resources. ex: production1"
}

variable "cidr" {
  description = "CIDR Block for the VPC"
  default     = "10.21.0.0/16"
}

variable "subnet" {
  description = "Subnet to create for the instance"
  default     = "10.21.1.0/24"
}

variable "tags" {
  description = "Tags to assign to the resources"
  default     = {}
}
