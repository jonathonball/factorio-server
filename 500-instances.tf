resource "aws_instance" "factorio_server" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t3.micro"
  key_name        = "${aws_key_pair.jball_key_pair.key_name}"
  security_groups = [ "${aws_security_group.game.name}" ]

  tags = {
    Name = "factorio"
  }
}

resource "aws_eip" "game_eip" {
  instance = "${aws_instance.factorio_server.id}"
}

resource "aws_ebs_volume" "save_games_ebs_volume" {
  availability_zone = "${aws_instance.factorio_server.availability_zone}"
  size              = 2

  tags = {
    Name = "factorio_saves"
  }
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.save_games_ebs_volume.id}"
  instance_id = "${aws_instance.factorio_server.id}"
}
