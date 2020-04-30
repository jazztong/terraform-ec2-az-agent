variable "app_env" {
  description = "Environment flag"
  type        = string
  default     = "dev"
}

variable "app_id" {
  description = "Application ID"
  type        = string
  default     = "AZURE-AGENT"
}

variable "region" {
  description = "Region to run provision the ec2"
  type        = string
  default     = "ap-southeast-1"
}

variable "enable_eip" {
  description = "Attach EIP"
  type        = bool
  default     = true
}

variable "user_name" {
  description = "User name to login machine"
  type        = string
  default     = "ec2-user"
}

variable "ami" {
  description = "Amazon Linux AMI"
  type        = string
  default     = "ami-0cbc6aae997c6538a"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.small"
}

variable "ecr_account" {
  description = "AWS Account number that host the ECR"
  type        = string
  default     = "210636571704"
}

variable "docker_compose_file" {
  description = "Docker compose yml file to build applications"
  type        = string
  default     = "docker-compose.yml"
}

variable "cloud_init_file" {
  description = "Cloud init template file for user data"
  type        = string
  default     = "cloud-init.tmpl"
}

variable "tags" {
  description = "tags applied to all resources"
  type        = map(string)
  default = {
    Project    = "MyProject"
    Department = "MyDeprt"
    Team       = "MyTeam"
    Company    = "MyCompany"
  }
}

