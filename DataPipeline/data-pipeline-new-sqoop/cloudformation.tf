resource "aws_cloudformation_stack" "sqoop_pipeline" {
  name = "${terraform.workspace}${var.CloudFormationStackName}"

  parameters {
    myS3PipelineLogUrl = "${var.S3PipelineLogUrl}"
    myDataPipelineName = "${terraform.workspace}-${var.DataPipelineName}"
    myPythonScript     = "${var.pythonScript}"
    myPythonScriptProp = "${var.pythonScriptProp}"
    myTableIngestion   = "${var.tableIngestion}"
  }

  template_body = "${file("${path.module}/data-pipeline-sqoop.json")}"
}
