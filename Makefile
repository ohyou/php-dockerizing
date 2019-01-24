define for_each_project
	find projects -mindepth 1 -maxdepth 1 -type d -exec printf "\n\n\-\-\- {} \-\-\-\n\n\n" \; -exec $(1) \;
endef

clean:
	$(call for_each_project, rm -rf {}/.terraform)

init:
	$(call for_each_project, terraform init {})

plan:
	terragrunt plan-all

apply:
	terragrunt apply-all

destroy:
	$(call for_each_project, terraform destroy -auto-approve {})