resource "aws_instance" "factorio_server" {
  ami              = "${ data.aws_ami.amazon.id }"
  instance_type    = "t3.micro"
  key_name         = "${ aws_key_pair.jball_key_pair.key_name }"
  security_groups  = [ "${ aws_security_group.game.name }" ]
  user_data_base64 = "${ data.template_cloudinit_config.factorio_config.rendered }"

  tags = {
    Name = "factorio"
  }
}

resource "aws_eip" "game_eip" {
  instance = "${ aws_instance.factorio_server.id }"
}

data "aws_ebs_volume" "save_games_ebs_volume" {
  most_recent = true

  filter {
    name = "tag:Name"
    values = ["factorio_saves"]
  }
}

variable "save_games_ebs_volume_ephemeral_name" {
  type = "string"
  default = "sdx"
}

resource "aws_volume_attachment" "ebs_att" {
  device_name  = "/dev/${ var.save_games_ebs_volume_ephemeral_name }"
  volume_id    = "${ data.aws_ebs_volume.save_games_ebs_volume.id }"
  instance_id  = "${ aws_instance.factorio_server.id }"
}
