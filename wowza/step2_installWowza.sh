#!/bin/bash

echo "======================== Step 2 Started ========================"

# download wowza installer
wget {{file url}}
sudo chmod +x WowzaStreamingEngine-4.8.18+1-linux-x64-installer.run
# install wowza
sudo ./WowzaStreamingEngine-4.8.18+1-linux-x64-installer.run

echo "======================== Step 2 Finished ========================"