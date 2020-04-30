provider "aws" {
  region = "ap-southeast-1"
  //Should assume role to kwms3-dev account
}

module "main" {
  source = "../main"
}

output "private_pem" {
  value = module.main.private_pem
}

output "public_ip" {
  value = module.main.public_ip
}
