
output "redshift_cluster_id" {
  value = "${aws_redshift_cluster.main_redshift_cluster.id}"
}

output "redshift_cluster_address" {
  value = "${replace(aws_redshift_cluster.main_redshift_cluster.endpoint, format(":%s", aws_redshift_cluster.main_redshift_cluster.port), "")}"
}

output "redshift_cluster_endpoint" {
  value = "${aws_redshift_cluster.main_redshift_cluster.endpoint}"
}


