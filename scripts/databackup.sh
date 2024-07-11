#!/bin/bash
set -eu

yum update -y
yum install -y awscli

cat <<EOL > ~/backup.sh
#!/bin/bash
set -eu

tar -czf ~/\$(date +%Y-%m-%d).tar.gz ~/backup
aws s3 cp ~/\$(date +%Y-%m-%d).tar.gz s3://harry-tf/
rm ~/\$(date +%Y-%m-%d).tar.gz # tidy up
EOL

chmod +x ~/backup.sh

~/backup.sh

# Very snazzy, -l lists all crons, echos mine on the end, piped into a replace (-) - https://stackoverflow.com/a/16068840
# also cron_tz sets the cron timezone
(crontab -l ; echo "CRON_TZ=Etc/UTC\n0 2 * * * ~/backup.sh") | crontab -