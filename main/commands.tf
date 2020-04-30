resource "null_resource" "wait_ready" {
  count      = 0
  depends_on = [module.ec2.id]

  triggers = {
    ec2 = join(",", module.ec2.id)
  }

  connection {
    host        = module.ec2.public_ip[0]
    user        = var.user_name
    private_key = tls_private_key.key.private_key_pem
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cloud-init status --wait",
      "ls /tmp/",
      "echo 'Machine Ready...'"
    ]
  }
}

resource "null_resource" "command" {
  count      = 0
  depends_on = [null_resource.wait_ready]

  triggers = {
    artifact       = join(",", [var.artifact.webapi])
    docker-compose = filemd5(var.docker_compose_file)
  }

  connection {
    host        = module.ec2.public_ip[0]
    user        = var.user_name
    private_key = tls_private_key.key.private_key_pem
  }

  provisioner "file" {
    source      = "${path.module}/../${var.docker_compose_file}"
    destination = "/tmp/${var.docker_compose_file}"
  }

  provisioner "remote-exec" {
    inline = [
      "ls /tmp/",
      "docker info",
      "echo 'export IMAGE_WEBAPI=${var.artifact.webapi}' >> ~/.bashrc",
      "source ~/.bashrc",
      "eval $(aws ecr get-login --registry-ids ${var.ecr_account} --no-include-email --region ${var.region} | sed 's;https://;;g')",
      "docker stack deploy --compose-file /tmp/${var.docker_compose_file} --with-registry-auth main"
    ]
  }
}
