#!/usr/bin/env bash

secrets_bucket="<SECRETS_BUCKET>"
env="<ENV>"

# Create SSH users
mkdir -p /tmp/pub

aws s3 sync s3://${secrets_bucket}/ssh/${env}/ /tmp/pub/

DEL_LIST=$(ls -lA /tmp/pub/delete | awk {'print $9'}| awk -F"." {'print $1'} | awk '/./')
USER_LIST=$(ls -lA /tmp/pub/users | awk {'print $9'}| awk -F"." {'print $1'} | awk '/./')
ADMIN_LIST=$(ls -lA /tmp/pub/admin | awk {'print $9'}| awk -F"." {'print $1'} | awk '/./')

# Delete users
for user in ${DEL_LIST}
do
  userdel $user
done

# Create Regular Users
for user in ${USER_LIST}
do
  useradd -m $user -s /bin/bash
  mkdir -p /home/${user}/.ssh
  cp /tmp/pub/users/${user}.pub /home/${user}/.ssh/authorized_keys
  chown -R ${user}:${user} /home/${user}/.ssh/
done

# Create Admin (Sudo) users
for admin in ${ADMIN_LIST}
do
  useradd -m $admin -s /bin/bash
  usermod -a -G wheel $admin
  mkdir -p /home/${admin}/.ssh
  cp /tmp/pub/admin/${admin}.pub /home/${admin}/.ssh/authorized_keys
  chown -R ${admin}:${admin} /home/${admin}/.ssh/

DATE=$(date)

cat << EOF > 100-$admin
# file for $admin created on $DATE
${admin} ALL=(ALL) NOPASSWD:ALL
EOF
    mv 100-$admin /etc/sudoers.d/

done

# Clean up.

rm -rf /tmp/pub/

# Remove the default ec2-user from the system
#userdel ec2-user