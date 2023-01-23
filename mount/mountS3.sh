#!/bin/bash
BUCKET="{{bucket name}}"
MOUNT_PATH="/mnt/my"

echo "==================== Mount S3 bucket started ===================="

sudo yum -y install golang fuse

sudo sh -c "echo 'export GOROOT=/usr/lib/golang' >> /etc/profile"
sudo sh -c "echo 'export GOBIN=\$GOROOT/bin' >> /etc/profile"

source /etc/profile
# install goofys
sudo wget http://bit.ly/goofys-latest -O /usr/bin/goofys
sudo chmod 755 /usr/bin/goofys
goofys --version

# create mount dir
sudo mkdir -p $MOUNT_PATH
echo "Mounting..."
# mount
sudo goofys -o allow_other $BUCKET $MOUNT_PATH
echo "Mount finished"
# for reboot
sudo sh -c "echo '/usr/bin/goofys#$BUCKET $MOUNT_PATH fuse _netdev,allow_other 0 0' >> /etc/fstab"

echo "==================== Mount S3 bucket finished ===================="