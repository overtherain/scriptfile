#!/bin/bash
shelldir=${SDK_HOME}/platform-tools
shelldir=
adb kill-server
sudo `which adb` start-server
sudo `which adb` devices
exit 0
sudo ${shelldir}/./adb start-server
sudo ${shelldir}/./adb devices
#sudo adb devices
