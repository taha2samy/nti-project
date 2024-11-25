output "backup_vault_arn" {
  value = aws_backup_vault.jenkins_vault.arn
}

output "backup_plan_id" {
  value = aws_backup_plan.jenkins_backup_plan.id
}
