# Terraform Setup for EC2 with Azure DevOps Agent

This project use terraform to setup EC2 for Azure DevOps Private Agent

## Getting Started

### Prerequisites

Please install the following tools to prepare you to manage this project

- [Terraform](https://brewinstall.org/install-terraform-on-mac-with-brew/)
- [Terraform on Window](https://computingforgeeks.com/install-and-use-terraform-on-windows/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Docker](https://docs.docker.com/install/)

#### Visual Studio Code Plugin

- [Markdown Preview](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced)
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [Commitizen Support](https://marketplace.visualstudio.com/items?itemName=KnisterPeter.vscode-commitizen)
- [Terraform Plugin](https://marketplace.visualstudio.com/items?itemName=mauve.terraform)

#### Git hooks Plug in

- [Pre-commit Terraform](https://github.com/antonbabenko/pre-commit-terraform)

## Coding style

Formatting is very important in code maintainability, run the following fmt update style

```
terraform fmt -recursive -check aws
```

## Auto generate Terraform Read me

Run the following command to auto generate terraform readme, ensure you have readme file in that folder with this section

```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
```

Run the following command to auto generate module definition into the block

```
pre-commit run -a
```

## Development override setting

As of the security concern, actual terraform token is not commit in this source control, when setup repo, you require to create one file `override.tf` and put under folder terraform in the following content:-

## Deployment work flow

> Make sure you configure `override.tf`

- Checkout source
- Create new feature branch with format `git checkout -b feature/{Ticket/Enhancment}`
- Add new repo file in the folder terraform
- Run `terraform init terraform` to initialize terraform
- Run `terraform plan terraform` to check the planning
- When no error show in planning stage, you can run `git add .` to add new files
- In VSCode, press **Shift+Command+P** to open command toggle, select `Commitizen: conventional commit`, and select your change type, and fill in require information
- Run `git push` to push to server, and create new Pull Request
- After Pull Request approve, merge to `master` branch, the actual provision will be execute

## Update Images

Update image name in [artifact.tf](main/artifact.tf), and after provision the respective environment will update latest image

## Update Docker Compose specification

Update [docker-compose.yml](docker-compose.yml) and commit to respective branch, it will provision the latest docker environment

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning.

## Authors

- **Jazz Tong** - _Initial work_

## License

This project no License

## Know issue

- **Auto scaling** - Currently only working on single manager swarm mode, will enhance for multi manager and multi nodes
- **First time boot Slow** - Can change to custom AMI to speedup the boot time, and remove some initialization logic
- **Not include Front tier load balancer** - The request is routing through port number, to use path routing will need to provision ALB or NLB + APIGW to route request by path

## Appendix

- [Terraform Basic](https://www.terraform.io/intro/index.html)
- The project heavily require understanding of [Terraform Enterprise Provider](https://www.terraform.io/docs/providers/tfe/index.html)
- This project follow [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/) specification
- To setup new VCS provider in Terraform Cloud, please follow [here](https://www.terraform.io/docs/cloud/vcs/bitbucket-cloud.html)
- This project use cloud-init as initialization scripting in cloud machine, read more on [Cloud-init](https://cloudinit.readthedocs.io/en/latest/)
