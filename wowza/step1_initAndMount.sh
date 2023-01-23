#!/bin/bash

if [ -z "$1" ]
then
    echo "input wowza doamin"
    exit
fi

echo "======================== Step 1 Started ========================"
# 도메인 환경 설정
sudo mkdir -p /root/.env
sudo sh -c "echo 'WOWZA_DOMAIN=$1' > /root/.env/wowza.env"
sudo cat /root/.env/wowza.env

# update os
sudo yum -y upgrade
# copy aws credentials
sudo cp -fr ../aws /root/.aws
# 타임존 변경. ZONE="Asia/Seoul" 로 설정
sudo sh -c "echo 'ZONE=\"Asia/Seoul\"' > /etc/sysconfig/clock"
# 본래 있던 값 그대로 넣음. 매뉴얼에는 해당 값 관련 아래와 같은 설명이 있음.
# "UTC=true 항목을 다른 값으로 변경하지 마십시오. 이 항목은 하드웨어 클록에 대한 것으로, 인스턴스에 대해 다른 표준 시간대를 설정할 때 따로 조정할 필요가 없습니다."
sudo sh -c "echo 'UTC=true' >> /etc/sysconfig/clock"
sudo cat /etc/sysconfig/clock
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime

# mount efs to /mnt/nas
sh ./mount/mountEfs.sh
# mount S3 bucket to /mnt/objs
sh ./mount/mountS3.sh

echo "======================== Step 1 Finished - Reboot system  after 5 seconds ========================"

sleep 5
sudo reboot