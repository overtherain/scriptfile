#!/bin/bash
shelldir=${SDK_HOME}/platform-tools
shelldir=
adb kill-server
sudo adb start-server
sudo adb devices
exit 0
sudo ${shelldir}/./adb start-server
sudo ${shelldir}/./adb devices
#sudo adb devices
