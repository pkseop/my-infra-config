#!/bin/bash

sudo amazon-linux-extras install docker -y

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -a -G docker ec2-user

sudo docker pull rabbitmq:management

sudo docker run -d --hostname rabbit2 \
  --add-host rabbit1:{{private ip}} \
  --add-host rabbit2:{{private ip}} \
  --name myrabbit2 \
  --restart unless-stopped \
  -p 4369:4369 \
  -p 25672:25672 \
  -p 35197:35197 \
  -p 15672:15672 \
  -p 5672:5672 \
  -e RABBITMQ_ERLANG_COOKIE=myrabbit \
  -e RABBITMQ_DEFAULT_USER=my \
  -e RABBITMQ_DEFAULT_PASS=mypass1@ \
  rabbitmq:management

sudo docker exec -it myrabbit2 bash
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl join_cluster --ram rabbit@rabbit1
rabbitmqctl start_app