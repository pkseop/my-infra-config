#!/bin/bash
MOUNT_PATH="/mnt/nas"
FS_ID="{{fs id}}"
FS_AP_ID="{{fsap id}}"

echo "==================== Mount EFS started ===================="

# EFS mount helper 설치
sudo yum install -y amazon-efs-utils
# NFS client 설치
sudo yum -y install nfs-utils
# NFS 서비스 시작
sudo service nfs-server start
# 서비스 정상 구동 확인
sudo service nfs status

sudo mkdir -p $MOUNT_PATH
# 마운트
echo "Mounting EFS..."
sudo mount -t efs -o tls,accesspoint=$FS_AP_ID $FS_ID:/ $MOUNT_PATH
echo "Mounted"

sudo sh -c "echo '$FS_ID:/ $MOUNT_PATH efs _netdev,tls,accesspoint=$FS_AP_ID 0 0' >> /etc/fstab"

echo "==================== Mount EFS finished ===================="