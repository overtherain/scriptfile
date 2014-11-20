#!/bin/bash
ct=`ps aux | grep adb | grep root | wc -l`
lsusb
echo adbd count is : $ct
case $ct in
	0)
		echo No need root permission
		echo `which adb` kill-server
		`which adb` kill-server
		echo `which adb` start-server
		`which adb` start-server
		echo `which adb` devices
		`which adb` devices
		;;
	*)
		echo Need root permission
		echo sudo `which adb` kill-server
		sudo `which adb` kill-server
		echo sudo `which adb` start-server
		sudo `which adb` start-server
		echo sudo `which adb` devices
		sudo `which adb` devices
		;;
esac
