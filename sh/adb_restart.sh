#!/bin/bash
shelldir=${SDK_HOME}/platform-tools
adb kill-server
sudo ${shelldir}/./adb start-server
sudo ${shelldir}/./adb devices
#sudo adb devices
