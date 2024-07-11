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

(crontab -l ; echo "0 2 * * * TZ=Etc/UTC ~/backup.sh") | crontab -
