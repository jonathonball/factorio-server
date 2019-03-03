resource "aws_security_group" "game" {

  # allow all out to all
  egress {
      from_port = "0"
      to_port   = "0"
      protocol  = "-1"
      self      = "true"
  }

  # allow ssh to all
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "50000"
    to_port     = "50000"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "50000"
    to_port     = "50000"
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}