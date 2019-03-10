data "template_file" "init-script" {
  template = "${ file("scripts/init.yaml") }"

  vars = {
    volume_ephemeral_name = "${var.save_games_ebs_volume_ephemeral_name}"
  }
}

data "template_file" "mount-script" {
  template = "${ file("scripts/mount.sh")}"

  vars = {
    volume_ephemeral_name = "${ var.save_games_ebs_volume_ephemeral_name }"
    log_path              = "/var/log/nvme.log"
    mountpoint            = "/opt/factorio"
  }
}

data "template_cloudinit_config" "factorio_config" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = "${ data.template_file.init-script.rendered }"
  }

  part {
    content_type = "text/x-shellscript"
    content      = "${ data.template_file.mount-script.rendered }"
 }
}
