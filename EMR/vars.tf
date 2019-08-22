variable "project" {
  description = "Description of the project (ex: kroton-analytics)."
}

variable "env" {
  description = "Environment (dev, homolog, prod)."
}

variable "env_infra" {
  description = "Infrastructure environment (dev, homolog, prod)."
}

variable "account_number" {
  description = "AWS account number."
}

variable "region" {
  description = "AWS region to use (default: us-east-1)."
}

variable "bucket_state" {
  description = "S3 bucket where the state files are stored."
}

variable "vpc_state_key_name" {
  description = "State file key name for VPC module."
}

variable "security_group_state_key_name" {
  description = "State file key name for SecurityGroup module."
}

variable "emr_release" {
  description = "EMR release to use (default: emr-5.14.0)."
  default = "emr-5.14.0"
}

variable "emr_services" {
  description = "EMR services to install (default: [Spark])."
  type    = "list"
  default = ["Spark"]
}

variable "key_name" {
  description = "Key-pair name to use to connect using ssh (default: kroton-prod-key-pair)."
  default = "kroton-prod-key-pair"
}

variable "logs_bucket" {
  description = "S3 bucket where the EMR log files are located."
}

variable "logs_path" {
  description = "S3 keypath where the EMR log files are located."
}

variable "master_instance_type" {
  description = "Instance type for master node."
}

variable "core_instance_type" {
  description = "Instance type for core nodes."
}

variable "core_instance_count" {
  description = "Total number of core instances to start up."
}

variable "core_bid_price" {
  description = "Bid price for task instance (in dollars)."
}

variable "task_instance_type" {
  description = "Instance type for task nodes."
}

variable "task_instance_count" {
  description = "Total number of task instances to start up."
}

variable "task_bid_price" {
  description = "Bid price for task instance (in dollars)."
}

variable "min_auto_scaling_task_nodes" {
  description = "Minimum task nodes for auto-scaling."
}

variable "max_auto_scaling_task_nodes" {
  description = "Maximum task nodes for auto-scaling."
}

variable "ebs_root_volume_size" {
  description = "EBS root volume size for EMR (default: 100)."
  default = 100
}

variable "bootstrap_bucket" {
  description = "S3 bucket where the bootstrap script file is located."
}

variable "bootstrap_key" {
  description = "S3 keypath where the bootstrap script file is located."
}

variable "ssh_bucket" {
  description = "S3 bucket where the ssh private key for github is located."
}

variable "ssh_key" {
  description = "S3 keypath where the ssh private key for github is located."
}

variable "configpy_bucket" {
  description = "S3 bucket where the config.py file is located."
}

variable "configpy_key" {
  description = "S3 keypath where the config.py file is located."
}

variable "project_bucket" {
  description = "S3 bucket where the project files are located."
}

variable "project_archive_bucket" {
  description = "S3 bucket where the project archive files are located."
}

variable "git_repository" {
  description = "Prefix of Git URL where the project is (ex: git@github.com:<git_root>)"
}

variable "desc" {
  description = "Project name (also the git repository name)."
}

variable "git_branch" {
  description = "Git branch to use for the project."
}

variable "deploy" {
  description = "Whether or not to flag the system as deploy-ready (\"true\"/\"false\")"
}

variable "spark_defaults_executor_instances" {
  description = "Value to use for spark-conf's spark.executor.instances variable."
  default = "6"
}

variable "spark_defaults_executor_memoryOverhead" {
  description = "Value to use for spark-conf's spark.executor.memoryOverhead variable."
  default = "1024"
}

variable "spark_defaults_executor_memory" {
  description = "Value to use for spark-conf's spark.executor.memory variable."
  default = "9G"
}

variable "spark_defaults_driver_memoryOverhead" {
  description = "Value to use for spark-conf's spark.driver.memoryOverhead variable."
  default = "2048"
}

variable "spark_defaults_driver_memory" {
  description = "Value to use for spark-conf's spark.driver.memory variable."
  default = "13G"
}

variable "spark_defaults_executor_cores" {
  description = "Value to use for spark-conf's spark.executor.cores variable."
  default = "1"
}

variable "spark_defaults_driver_cores" {
  description = "Value to use for spark-conf's spark.driver.cores variable."
  default = "3"
}

variable "spark_defaults_default_parallelism" {
  description = "Value to use for spark-conf's spark.default.parallelism variable."
  default = "12"
}

variable "spark_defaults_sql_shuffle_partitions" {
  description = "Value to use for spark-conf's spark.sql.shuffle.partitions variable."
  default = "12"
}
