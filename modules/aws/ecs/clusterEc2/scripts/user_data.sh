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
stack_type="${stack_type}"

device_name_ecs="${device_name_ecs}"
ecs_log_level="${ecs_log_level}"
ecs_cluster="${ecs_cluster}"

ecs_reserved_memory="${ecs_reserved_memory}"
ecs_instance_attributes="${ecs_instance_attributes}"
ecs_reserved_memory="${ecs_reserved_memory}"
ecs_instance_attributes="${ecs_instance_attributes}"
ecs_engine_auth_type="${ecs_engine_auth_type}"
ecs_engine_auth_data="${ecs_engine_auth_data}"
docker_host="${docker_host}"
ecs_logfile="${ecs_logfile}"
ecs_checkpoint="${ecs_checkpoint}"
ecs_datadir="${ecs_datadir}"
ecs_disable_privileged="${ecs_disable_privileged}"
ecs_container_stop_timeout="${ecs_container_stop_timeout}"
ecs_container_start_timeout="${ecs_container_start_timeout}"
ecs_disable_image_cleanup="${ecs_disable_image_cleanup}"
ecs_image_cleanup_interval="${ecs_image_cleanup_interval}"
ecs_image_minimum_cleanup_age="${ecs_image_minimum_cleanup_age}"
ecs_enable_container_metadata="${ecs_enable_container_metadata}"


del_ec2_user="${del_ec2_user}"

# Force the update.
yum update -y

# Software packages:
yum install -y awslogs vim jq unzip wget tree git

###########################################
# Install/configure cloudwatch logs agent #
###########################################
systemctl enable awslogsd.service
systemctl stop awslogsd


mv /etc/awslogs/awslogs.conf{,.old}
mv /etc/awslogs/awscli.conf{,.old}

aws s3 cp s3://${config_bucket}/cloudwatch/ecs/awslogs/awslogs.conf /etc/awslogs/awslogs.conf
aws s3 cp s3://${config_bucket}/cloudwatch/ecs/awslogs/awscli.conf /etc/awslogs/awscli.conf

sed -i -e "s.<LOG_GROUP>.${loggroup}." /etc/awslogs/awslogs.conf
sed -i -e "s.<REGION>.${region}." /etc/awslogs/awscli.conf

# Enable Cloudwatch agent advanced metrics

curl -O https://s3.amazonaws.com/amazoncloudwatch-agent/linux/${ami_architecture}/latest/AmazonCloudWatchAgent.zip
unzip AmazonCloudWatchAgent.zip
./install.sh

aws s3 cp s3://${config_bucket}/cloudwatch/ecs/awslogs/awslogs.json .

sed -i -e "s.<LOG_GROUP>.${loggroup}.g" ./awslogs.json

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:./awslogs.json -s

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -m auto -c default

systemctl start awslogsd


##################################
# Install/configure ECS instance #
##################################
systemctl enable ecs.service
systemctl stop ecs.service

# Prevent any ECS tasks from assuning ec2 Role
#iptables --insert FORWARD 1 --in-interface docker+ --destination 169.254.169.254/32 --jump DROP

# Remove all config files
mv /etc/ecs/ecs.config{,.old}
mv /var/lib/ecs/data/ecs_agent_data{,.old}.json

# Create the new 'ecs.config' file

echo "ECS_CLUSTER=${ecs_cluster}" > /etc/ecs/ecs.config
echo "ECS_LOGLEVEL=${ecs_log_level}" >> /etc/ecs/ecs.config
echo "AWS_REGION=${region}" >> /etc/ecs/ecs.config
echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"json-file\",\"awslogs\"]" >> /etc/ecs/ecs.config

# Additional options for ecs.conf
[ ! -n "$${ecs_reserved_memory}" ] && echo "ecs_reserved_memory not set, ignoring..." || echo "ECS_RESERVED_MEMORY=${ecs_reserved_memory}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_instance_attributes}" ] && echo "ecs_instance_attributes not set, ignoring..." || echo "ECS_INSTANCE_ATTRIBUTES=${ecs_instance_attributes}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_engine_auth_type}" ] && echo "ecs_engine_auth_type not set, ignoring..." || echo "ECS_ENGINE_AUTH_TYPE=${ecs_engine_auth_type}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_engine_auth_data}" ] && echo "ecs_engine_auth_data not set, ignoring..." || echo "ECS_ENGINE_AUTH_DATA=${ecs_engine_auth_data}" >> /etc/ecs/ecs.config
[ ! -n "$${docker_host}" ] && echo "docker_host not set, ignoring..." || echo "DOCKER_HOST=${docker_host}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_logfile}" ] && echo "ecs_logfile not set, ignoring..." || echo "ECS_LOGFILE=${ecs_logfile}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_checkpoint}" ] && echo "ecs_checkpoint not set, ignoring..." || echo "ECS_CHECKPOINT=${ecs_checkpoint}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_datadir}" ] && echo "ecs_datadir not set, ignoring..." || echo "ECS_DATADIR=${ecs_datadir}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_disable_privileged}" ] && echo "ecs_disable_privileged not set, ignoring..." || echo "ECS_DISABLE_PRIVILEGED=${ecs_disable_privileged}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_container_stop_timeout}" ] && echo "ecs_container_stop_timeout not set, ignoring..." || echo "ECS_CONTAINER_STOP_TIMEOUT=${ecs_container_stop_timeout}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_container_start_timeout}" ] && echo "ecs_reserved_memory not set, ignoring..." || echo "ECS_CONTAINER_START_TIMEOUT=${ecs_container_start_timeout}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_disable_image_cleanup}" ] && echo "ecs_disable_image_cleanup not set, ignoring..." || echo "ECS_DISABLE_IMAGE_CLEANUP=${ecs_disable_image_cleanup}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_image_cleanup_interval}" ] && echo "ecs_image_cleanup_interval not set, ignoring..." || echo "ECS_IMAGE_CLEANUP_INTERVAL=${ecs_image_cleanup_interval}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_image_minimum_cleanup_age}" ] && echo "ecs_image_minimum_cleanup_age not set, ignoring..." || echo "ECS_IMAGE_MINIMUM_CLEANUP_AGE=${ecs_image_minimum_cleanup_age}" >> /etc/ecs/ecs.config
[ ! -n "$${ecs_enable_container_metadata}" ] && echo "ecs_enable_container_metadata not set, ignoring..." || echo "ECS_ENABLE_CONTAINER_METADATA=${ecs_enable_container_metadata}" >> /etc/ecs/ecs.config

# Partition data volume and add the ecs folder structure
mkdir -p /data
ebsnvme-id ${device_name_ecs}
echo y | mkfs -t ext4 -q ${device_name_ecs}
e2label ${device_name_ecs} data
cp /etc/fstab{,.bak}
echo "LABEL=data    /data    ext4    defaults,nofail    0    2" >> /etc/fstab
mount -a
mkdir -p /data/ecs/services


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

# Remove the default ec2-user from the system
if [ $${del_ec2_user} == "true" ]; then
    pkill -u ec2-user
    passwd -l ec2-user
    userdel -fr ec2-user
fi

# Start the ecs service...
# Because we are using Cloudinit there are a couple of steps needed to enable
# ECS service, see: https://github.com/aws/amazon-ecs-agent/issues/1707
systemctl enable --now --no-block ecs.service

