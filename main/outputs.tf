output "public_ip" {
  value = aws_eip.ips.*.public_ip
}

output "private_pem" {
  value = tls_private_key.key.private_key_pem
}
