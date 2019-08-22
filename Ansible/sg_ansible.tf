resource "aws_security_group" "ansible" {
  name = "ansible"

  vpc_id = "${var.vpc_id}"

  # Allow all inbound
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["200.233.156.33/32"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
