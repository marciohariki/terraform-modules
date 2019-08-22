#lookup parameters for specic RDS types
variable "default_db_parameters" {
  default = {
    mysql = [
      {
        name  = "slow_query_log"
        value = "1"
      },
      {
        name  = "long_query_time"
        value = "1"
      },
      {
        name  = "general_log"
        value = "0"
      },
      {
        name  = "log_output"
        value = "FILE"
      },
    ]

    postgres = []
    oracle   = []
  }
}

variable "default_ports" {
  default = {
    mysql    = "3306"
    postgres = "5432"
    oracle   = "1521"
  }
}

variable "project" {
  description = "The current project"
}

variable "projectlower" {
  description = "The current project in lower case"
}

variable "storage" {
  description = "How many GBs of space does your database need?"
  default     = "10"
}

variable "size" {
  description = "Instance size"
  default     = "db.t2.small"
}

variable "storage_type" {
  description = "Type of storage you want to use"
  default     = "standard"
}

variable "rds_user" {
  description = "RDS root user"
}

variable "rds_password" {
  description = "RDS root password"
}

variable "engine" {
  description = "RDS engine: mysql, oracle, postgres. Defaults to postgres"
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version to use, according to the chosen engine. You can check the available engine versions using the AWS CLI (http://docs.aws.amazon.com/cli/latest/reference/rds/describe-db-engine-versions.html). Defaults to 5.7.17 for MySQL."
  default     = "9.6.6"
}

variable "default_parameter_group_family" {
  description = "Parameter group family for the default parameter group, according to the chosen engine and engine version. Will be omitted if `rds_custom_parameter_group_name` is provided. Defaults to mysql5.7"
  default     = "postgres9.6"
}

variable "replicate_source_db" {
  description = "RDS source to replicate from"
  default     = ""
}

variable "multi_az" {
  description = "Multi AZ true or false"
  default     = false
}

variable "publicly_accessible" {
  description = "Check if publicly accessible"
  default     = true
}

variable "db_name" {
  description = "Db name"
  default     = "default"
}


variable "backup_retention_period" {
  description = "How long do you want to keep RDS backups"
  default     = "14"
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  default     = true
}

variable "storage_encrypted" {
  description = "Encrypt RDS storage"
  default     = false
}

variable "tag" {
  description = "A tag used to identify an RDS in a project that has more than one RDS"
  default     = ""
}

variable "number" {
  description = "number of the database "
  default     = ""
}

variable "rds_custom_parameter_group_name" {
  description = "A custom parameter group name to attach to the RDS instance. If not provided a default one will be created"
  default     = ""
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying RDS"
  default     = false
}

variable "availability_zone" {
  description = "The availability zone where you want to launch your instance in"
  default     = ""
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  default     = ""
}

variable "bucket_state" {}

variable "env_infra" {}

variable "security_group_state_key_name" {}
variable "vpc_state_key_name" {}

variable "region" {}

variable "env" {}
