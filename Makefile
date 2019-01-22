clean:
	find projects -maxdepth 1 -type d -exec rm -rf {}/.terraform \;

init:
	find projects -maxdepth 1 -type d -exec terraform init {}/ \;

plan:
	terragrunt plan-all

apply:
	terragrunt apply-all