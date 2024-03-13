AWS_REGION=us-east-1
IAC_BUCKET=iac-state-$(AWS_REGION)

create-iac-bucket:
	awslocal s3api create-bucket --region $(AWS_REGION) --bucket $(IAC_BUCKET)
	awslocal s3api put-bucket-versioning --bucket $(IAC_BUCKET) --versioning-configuration Status=Enabled

stack-init:
	tflocal init -upgrade -reconfigure

plan: stack-init
	tflocal plan

deploy: plan
	tflocal apply -auto-approve \
	&& tflocal output -json

outputs: stack-init
	tflocal output -json

destroy:
	terraform destroy; rm -rf .terraform

it-again: destroy deploy
