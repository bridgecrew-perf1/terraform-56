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

config_bucket="${config_bucket}"
secrets_bucket="${secrets_bucket}"
region="${region}"

del_ec2_user="${del_ec2_user}"

# Software packages:
yum install -y awslogs vim jq unzip wget tree git

###########################################
# Install/configure cloudwatch logs agent #
###########################################
systemctl enable awslogsd.service
systemctl stop awslogsd


mv /etc/awslogs/awslogs.conf{,.old}
mv /etc/awslogs/awscli.conf{,.old}

aws s3 cp s3://${config_bucket}/cloudwatch/default/awslogs/awslogs.conf /etc/awslogs/awslogs.conf
aws s3 cp s3://${config_bucket}/cloudwatch/default/awslogs/awscli.conf /etc/awslogs/awscli.conf

sed -i -e "s.<LOG_GROUP>.${loggroup}." /etc/awslogs/awslogs.conf
sed -i -e "s.<REGION>.${region}." /etc/awslogs/awscli.conf

# Enable Cloudwatch agent advanced metrics

curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/linux/${ami_architecture}/latest/AmazonCloudWatchAgent.zip
unzip AmazonCloudWatchAgent.zip
./install.sh

aws s3 cp s3://${config_bucket}/cloudwatch/default/awslogs/awslogs.json .

sed -i -e "s.<LOG_GROUP>.${loggroup}.g" ./awslogs.json

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:./awslogs.json -s

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -m auto -c default

systemctl start awslogsd

# Create ssh users and setup crontab schedule.
mkdir -p root
aws s3 cp s3://${config_bucket}/ssh/sync_ssh_users.sh /root/scripts/sync_ssh_users.sh && chmod +x /root/scripts/sync_ssh_users.sh

# Setup working variables

sed -i -e "s.<CONFIG_BUCKET>.${config_bucket}." /root/scripts/sync_ssh_users.sh
sed -i -e "s.<SECRETS_BUCKET>.${secrets_bucket}." /root/scripts/sync_ssh_users.sh
sed -i -e "s.<ENV>.${env}." /root/scripts/sync_ssh_users.sh
sed -i -e "s.<STACK_TYPE>.${stack_type}." /root/scripts/sync_ssh_users.sh


# Execute initial creation
bash -x /root/scripts/sync_ssh_users.sh

# Setup cronjob with 30m intervals
crontab -l > mycron
echo "*/30 * * * * bash -x /root/scripts/sync_ssh_users.sh" >> setcron
crontab setcron
rm setcron

# Setup default port
if [ ${default_port} -ne 22 ]; then
   sudo sed -i -e "s.#Port 22.Port ${default_port}." /etc/ssh/sshd_config
   sudo systemctl restart sshd

   echo "New port set: "${default_port}
   echo "Netstat : "$(sudo netstat -tlpn | grep ssh | grep 0.0.0.0: )
fi

# Remove the default ec2-user from the system
if [ $${del_ec2_user} == "true" ]; then
    pkill -u ec2-user
    passwd -l ec2-user
    userdel -fr ec2-user
fi
