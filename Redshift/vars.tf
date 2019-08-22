variable "project" {
  default = "kroton-analytics"
}

variable "env" {
  default = "prod"
}

# Redshift Cluster Variables

variable "cluster_version" {
  description = "Version of Redshift engine cluster"
  default     = "1.0"

  # Constraints: Only version 1.0 is currently available.
  # http://docs.aws.amazon.com/cli/latest/reference/redshift/create-cluster.html
}

variable "cluster_node_type" {
  description = "Node Type of Redshift cluster"
  default     = "ds1.xlarge"

  # Valid Values: ds1.xlarge | ds1.8xlarge | ds2.xlarge | ds2.8xlarge | dc1.large | dc1.8xlarge.
  # http://docs.aws.amazon.com/cli/latest/reference/redshift/create-cluster.html
}

variable "cluster_number_of_nodes" {
  description = "Number of Node in the cluster"
  default     = 3
}

variable "cluster_database_name" {
  description = "The name of the database to create"
  default     = "kroton-analytics"
}

# Self-explainatory variables
variable "cluster_master_username" {
  default = "kroton-analytics"
}

variable "cluster_master_password" {
}

variable "cluster_port" {
  default = 5439
}

# This is for a custom parameter to be passed to the DB
# We're "cloning" default ones, but we need to specify which should be copied
variable "cluster_parameter_group" {
  description = "Parameter group, depends on DB engine used"
  default     = "redshift-1.0"
}

variable "publicly_accessible" {
  description = "Determines if Cluster can be publicly available (NOT recommended)"
  default     = false
}

variable "tier_subnet" {
  default = "Public"
}

variable "skip_final_snapshot" {
  description = "If true (default), no snapshot will be made before deleting DB"
  default     = true
}

variable "preferred_maintenance_window" {
  description = "When AWS can run snapshot, can't overlap with maintenance window"
  default     = "sat:10:00-sat:10:30"
}

variable "automated_snapshot_retention_period" {
  type        = "string"
  description = "How long will we retain backups"
  default     = 0
}

variable "wlm_json_configuration" {
  default = "[{\"query_concurrency\": 5}]"
}

variable "region" {}

variable "bucket_state" {}

variable "vpc_state_key_name" {}

variable "security_group_state_key_name" {
  description = "State file key name for SecurityGroup module."
}

variable "desc" {
  description = "Project name (also the git repository name)."
}

variable "project_bucket" {
  description = "S3 bucket where the project files are located."
}

variable "env_infra" {
  description = "Infrastructure environment (dev, homolog, prod)."
}