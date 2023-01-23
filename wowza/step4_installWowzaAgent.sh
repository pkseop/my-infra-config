#!/bin/bash
echo "======================== Step 4 Started ========================"
VERSION="2.6.5"

sudo amazon-linux-extras install docker -y
#docker start
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -a -G docker ec2-user

# 에이전트 설치...

echo "======================== Step 4 Finished ========================"
