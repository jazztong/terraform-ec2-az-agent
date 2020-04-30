# Main module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| null | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ami | Amazon Linux AMI | `string` | `"ami-0cbc6aae997c6538a"` | no |
| app\_env | Environment flag | `string` | `"dev"` | no |
| app\_id | Application ID | `string` | `"AZURE-AGENT"` | no |
| artifact | Artifact for deploy image url | `map` | <pre>{<br>  "webapi": "labs/lab_webapi_cs:v1.3.1"<br>}</pre> | no |
| cloud\_init\_file | Cloud init template file for user data | `string` | `"cloud-init.tmpl"` | no |
| docker\_compose\_file | Docker compose yml file to build applications | `string` | `"docker-compose.yml"` | no |
| ecr\_account | AWS Account number that host the ECR | `string` | `"210636571704"` | no |
| enable\_eip | Attach EIP | `bool` | `true` | no |
| instance\_type | Instance type | `string` | `"t2.small"` | no |
| region | Region to run provision the ec2 | `string` | `"ap-southeast-1"` | no |
| tags | tags applied to all resources | `map(string)` | <pre>{<br>  "Company": "MyCompany",<br>  "Department": "MyDeprt",<br>  "Project": "MyProject",<br>  "Team": "MyTeam"<br>}</pre> | no |
| user\_name | User name to login machine | `string` | `"ec2-user"` | no |

## Outputs

| Name | Description |
|------|-------------|
| private\_pem | n/a |
| public\_ip | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
