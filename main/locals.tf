locals {
  user_data = templatefile("cloud-init.tmpl", {
    ecr_account = var.ecr_account
    region      = var.region
    user_name   = var.user_name
  })
}

locals {
  app_id = "${lower(var.app_id)}-${lower(var.app_env)}"
  common_tags = merge(
    {
      CreateBy = "Terraform"
      Env      = var.app_env
    },
    var.tags
  )
}

locals {
  role_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
}
