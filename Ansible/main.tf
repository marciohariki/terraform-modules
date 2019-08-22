module "ansible" {
  source         = "../SpotInstance"
  user_data      = "${file("../../terraform-modules/Ansible/user_data.sh")}"
  priv_ip        = "172.31.16.50"
  name           = "${var.name}"
  sgs            = ["${aws_security_group.ansible.id}"]
  project        = "${var.project}"
  assoc_pub_ip   = true
  subnet_id      = "${var.subnet_id}"

}
