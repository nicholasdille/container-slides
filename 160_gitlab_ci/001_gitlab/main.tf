provider "gitlab" {
  base_url = "https://gitlab.${local.domain}/api/v4/"
  token = var.gitlab_token
}

resource "gitlab_user" "seats" {
  count = var.user_count

  name              = "seat${count.index}"
  username          = "seat${count.index}"
  password          = local.seats_password[count.index]
  email             = "seat${count.index}@inmylab.de"
  can_create_group  = true
  is_external       = false
  reset_password    = false
  skip_confirmation = true
}

resource "gitlab_personal_access_token" "seats_vscode" {
  count = var.user_count

  user_id    = gitlab_user.seats[count.index].id
  name       = "vscode"

  scopes = ["api", "read_user", "write_repository"]
}

resource "gitlab_project" "seats_demo" {
  count = var.user_count

  name        = "demo"
  description = "Demo"
  namespace_id = gitlab_user.seats[count.index].namespace_id

  visibility_level = "internal"

  default_branch = "main"
  initialize_with_readme = true
}

resource "gitlab_user_runner" "shared" {
  runner_type = "instance_type"

  description = "Shared runner"
  tag_list    = []
  untagged    = true
}