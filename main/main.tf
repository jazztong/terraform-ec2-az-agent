resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_iam_instance_profile" "profile" {
  name = "${local.app_id}-EC2-Profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "attachment" {
  count = length(local.role_policy_arns)

  role       = aws_iam_role.role.name
  policy_arn = element(local.role_policy_arns, count.index)
}

resource "aws_iam_role" "role" {
  name = "${local.app_id}-EC2-Role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_key_pair" "default" {
  key_name   = "${local.app_id}-keypair"
  public_key = tls_private_key.key.public_key_openssh

  tags = merge({ Name = "${local.app_id}-keypair" }, local.common_tags)
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "${local.app_id}-SG"
  description = "Security group for usage with EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  ingress_with_self = [
    { rule = "docker-swarm-mngmt-tcp" },
    { rule = "docker-swarm-node-tcp" },
    { rule = "docker-swarm-node-udp" },
    { rule = "docker-swarm-overlay-udp" },
  ]

  ingress_with_cidr_blocks = [
    { rule = "http-80-tcp", cidr_blocks = "0.0.0.0/0" },
    { rule = "http-8080-tcp", cidr_blocks = "0.0.0.0/0" },
    { rule = "all-icmp", cidr_blocks = "0.0.0.0/0" },
    { rule = "ssh-tcp", cidr_blocks = "0.0.0.0/0" },
  ]

  egress_rules = ["all-all"]
  tags         = merge({ Name = "${local.app_id}-sg" }, local.common_tags)
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "2.13.0"

  instance_count              = 1
  name                        = "${local.app_id}-EC2"
  ami                         = var.ami
  instance_type               = var.instance_type
  cpu_credits                 = "unlimited"
  subnet_id                   = tolist(data.aws_subnet_ids.all.ids)[0]
  vpc_security_group_ids      = [module.security_group.this_security_group_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.default.key_name
  iam_instance_profile        = aws_iam_instance_profile.profile.name

  user_data_base64 = base64encode(local.user_data)
  tags             = merge({ Name = "${local.app_id}-ec2" }, local.common_tags)
}

resource "aws_eip" "ips" {
  count    = var.enable_eip ? length(module.ec2.id) : 0
  instance = module.ec2.id[count.index]
}
