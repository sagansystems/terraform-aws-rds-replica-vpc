# terraform-aws-rds-replica-vpc

Terraform module to provision an AWS [`RDS`](https://aws.amazon.com/rds/) cross-region replica in its own VPC

The module will create:
* VPC
* Private Subnet
* DB Subnet Group
* RDS read replica instance

See:

* [Working with PostgreSQL, MySQL, and MariaDB Read Replicas](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_ReadRepl.html#USER_ReadRepl.XRgn)
* [CreateDBInstanceReadReplica API](http://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstanceReadReplica.html)
