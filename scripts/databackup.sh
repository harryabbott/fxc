#!/bin/bash
set -eu

# dont need sudo, ec2 userdata is ran as root
yum update -y
yum install -y awscli cronie
systemctl enable crond.service
systemctl start crond.service

mkdir -p /home/ec2-user/backup

cat <<EOL > /home/ec2-user/backup.sh
#!/bin/bash
set -eu

tar -czf /home/ec2-user/\$(date +%Y-%m-%d).tar.gz /home/ec2-user/backup
aws s3 cp /home/ec2-user/\$(date +%Y-%m-%d).tar.gz s3://harry-backup-123-789-456-fxc/
rm ~/\$(date +%Y-%m-%d).tar.gz # tidy up
EOL

chmod +x /home/ec2-user/backup.sh

/home/ec2-user/backup.sh

# Very snazzy, -l lists all crons, echos mine on the end, piped into a replace (-) - https://stackoverflow.com/a/16068840
# also cron_tz sets the cron timezone
(crontab -u ec2-user -l ; echo "CRON_TZ=Etc/UTC\n0 2 * * * /home/ec2-user/backup.sh") | crontab -