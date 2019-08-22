variable "S3PipelineLogUrl" {
  default = "s3://engenharia-informacao/data_pipeline"
}

variable "DataPipelineName" {}

variable "pythonScript" {
  default = "/home/hadoop/bin/sqoop/run_scoop.py"
}

variable "pythonScriptProp" {
  default = "/home/hadoop/bin/sqoop/run_scoop.json"
}

variable "tableIngestion" {}
variable "CloudFormationStackName" {}
