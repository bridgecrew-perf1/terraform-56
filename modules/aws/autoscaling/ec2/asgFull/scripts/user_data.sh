#!/bin/bash

DEBUG=$${DEBUG:=off}

if [ $${DEBUG} == 'on' ]; then
    set -x
fi

instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id | cut -d "-" -f 2)
container_instance_id=$(curl http://169.254.169.254/latest/meta-data/instance-id)

ami_architecture="${ami_architecture}"
loggroup="${loggroup}"
env="${env}"

region="$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document/ | jq -r '.region')"

# Software packages:
yum install -y awslogs vim jq unzip wget tree git

###########################################
# Install/configure cloudwatch logs agent #
###########################################
systemctl enable awslogsd.service
systemctl stop awslogsd


mv /etc/awslogs/awslogs.conf{,.old}
mv /etc/awslogs/awscli.conf{,.old}


[plugins]
cwlogs = cwlogs
[default]
region = $${region}

sed -i -e "s.<LOG_GROUP>.${loggroup}." /etc/awslogs/awslogs.conf
# sed -i -e "s.<REGION>.$${region}." /etc/awslogs/awscli.conf

# Enable Cloudwatch agent advanced metrics

curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/linux/${ami_architecture}/latest/AmazonCloudWatchAgent.zip
unzip AmazonCloudWatchAgent.zip
./install.sh

sed -i -e "s.<LOG_GROUP>.${loggroup}.g" ./awslogs.json

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:./awslogs.json -s

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -m auto -c default

systemctl start awslogsd


