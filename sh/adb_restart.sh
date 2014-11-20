#!/bin/bash
echo sudo `which adb` kill-server
sudo `which adb` kill-server
echo sudo `which adb` start-server
sudo `which adb` start-server
echo sudo `which adb` devices
sudo `which adb` devices
