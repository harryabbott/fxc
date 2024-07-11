variable "backup_bucket_name" {
  description = "The name of the S3 bucket for backups"
  type        = string
  default     = "harry-backup-123-789-456-fxc" #bad name bc s3 has to be globally unique
}