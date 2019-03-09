data "aws_ami" "amazon" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }
}