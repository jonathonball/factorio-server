resource "aws_instance" "factorio_server" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  key_name        = "${aws_key_pair.jball_key_pair.key_name}"
  security_groups = [ "${aws_security_group.game.name}" ]

  tags = {
    Name = "factorio"
  }
}

resource "aws_eip" "game_eip" {
  instance = "${aws_instance.factorio_server.id}"
}
