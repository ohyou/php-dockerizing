terragrunt = {
  terraform {
    extra_arguments "auth_vars" {
      commands = [
        "init",
        "apply",
        "refresh",
        "import",
        "plan",
        "taint",
        "untaint"
      ]

      arguments = [
        "-var-file=${get_tfvars_dir()}/auth.tfvars"
      ]
    }
  }
}
