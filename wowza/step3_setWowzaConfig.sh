#!/bin/bash

echo "======================== Step 3 Started ========================"

# 디렉토리 설정 ...


cd $pwd

#wowza restart 
sudo systemctl stop WowzaStreamingEngine.service
sudo systemctl start WowzaStreamingEngine.service
sudo systemctl restart WowzaStreamingEngineManager.service

echo ">>> Manager에 접속해서 application 설정 필요. <<<"
echo "======================== Step 3 Finished ========================"

# 설정이 빠진 부분이 많아서 이후로든 manager에 접속해서 설정 필요.
# 기존 그립 서비스의 wowza manager를 보고 application 설정을 똑같이 설정하면 됨.