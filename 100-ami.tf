data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
}