

resource "aws_backup_vault" "jenkins_vault" {
  name = "jenkins-backup-vault"
}

resource "aws_backup_plan" "jenkins_backup_plan" {
  name = "jenkins-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.jenkins_vault.name
    schedule          = "cron(0 12 * * ? *)" 
    lifecycle {
      delete_after = 30
    }
  }
}

resource "aws_backup_selection" "jenkins_backup_selection" {
  iam_role_arn = aws_iam_role.backup_role.arn
  name         = "jenkins-backup-selection"
  plan_id      = aws_backup_plan.jenkins_backup_plan.id

  resources = [
    "arn:aws:ec2:${var.region}:instance/${var.instance_id}"
  ]
}

resource "aws_iam_role" "backup_role" {
  name = "BackupServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backup_policy_attachment" {
  role       = aws_iam_role.backup_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
}