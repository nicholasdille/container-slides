output "personal_access_tokens" {
  value     = gitlab_personal_access_token.seats_vscode[*].token
  sensitive = true
}

output "runner_token" {
  value     = gitlab_user_runner.shared.token
  sensitive = true
}

output "app_id_glab" {
  value     = gitlab_application.glab.application_id
  sensitive = true
}

output "app_id_git" {
  value     = gitlab_application.git_credential_oauth.application_id
  sensitive = true
}