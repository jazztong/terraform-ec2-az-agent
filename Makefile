WORK_PATH = dev
ECR_HOST ?= 210636571704.dkr.ecr.ap-southeast-1.amazonaws.com
IMAGE_WEBAPI ?= labs/lab_webapi_cs:v1.1.4

fmt:
	terraform fmt -recursive -check ${WORK_PATH}

init:
	terraform init ${WORK_PATH}

plan:
	terraform plan ${WORK_PATH}

apply:
	terraform apply -auto-approve ${WORK_PATH}
	terraform output private_pem > ~/sanbox.pem

kill:
	terraform destroy -auto-approve ${WORK_PATH}

deploy:
	docker stack deploy --compose-file docker-compose.yml --with-registry-auth main

login:
	eval $(aws ecr get-login --registry-ids 210636571704 --no-include-email --region ap-southeast-1 --password-stdin | sed 's;https://;;g')

login2:
	echo $(aws ecr get-authorization-token --region ap-southeast-1 --output text --query 'authorizationData[].authorizationToken' | base64 -d | cut -d: -f2) | docker login -u AWS https://210636571704.dkr.ecr.ap-southeast-1.amazonaws.com --password-stdin

ecr-helper:
	jq '.credHelpers = {"210636571704.dkr.ecr.ap-southeast-1.amazonaws.com": "ecr-login"}' ~/.docker/config.json > "tmp" && mv "tmp" ~/.docker/config.json 