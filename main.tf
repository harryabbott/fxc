resource "aws_instance" "fxc-test" {
  ami                  = "ami-0fe310dde2a8fdc5c" #newest amazon linux as of 10/7/24
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.backup_profile.name

  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.fxc-sg.id]

  tags = {
    Name = "fxc-test"
  }

  user_data = file("scripts/databackup.sh")
}

resource "aws_s3_bucket" "backup_bucket" {
  bucket = var.backup_bucket_name
}

resource "aws_security_group" "fxc-sg" {
  name        = "fxc-sg"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "backup_role" { #linked to instance profile, used by script to s3 cp instance backups
  name = "backup_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "backup_policy" {
  name = "backup_policy"
  role = aws_iam_role.backup_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      Resource = "arn:aws:s3:::${var.backup_bucket_name}/*"
    }]
  })
}

resource "aws_iam_instance_profile" "backup_profile" {
  name = "backup_profile_harry_fxc_interview"
  role = aws_iam_role.backup_role.name
}