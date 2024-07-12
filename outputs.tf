locals {
  backup_date = formatdate("YYYY-MM-DD", timestamp())
}

output "backup_file_url" {
  description = "The URL of the uploaded backup file"
  value       = "https://${var.backup_bucket_name}.s3.amazonaws.com/backup-${local.backup_date}.tar.gz"
}

output "instance_public_ip" {
  description = "The public IP address of the instance"
  value       = aws_instance.fxc-test.public_ip
}