output "personal_access_tokens" {
    value = gitlab_personal_access_token.seats_vscode[*].token
    sensitive = true
}

output "runner_token" {
    value = gitlab_user_runner.shared.token
    sensitive = true
}