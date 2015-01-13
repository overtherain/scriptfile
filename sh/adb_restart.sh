#!/bin/bash
ps aux | grep adb | grep root | grep -v 'grep'
ct=`ps aux | grep adb | grep root | grep -v 'grep' | wc -l`
lsusb
echo adbd count is : $ct
echo `which adb` kill-server
`which adb` kill-server
echo sudo `which adb` start-server
sudo `which adb` start-server
echo `which adb` devices
`which adb` devices
exit 0
## the bellow is for normal
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
		echo `which adb` kill-server
		`which adb` kill-server
		echo sudo `which adb` start-server
		sudo `which adb` start-server
		echo `which adb` devices
		`which adb` devices
		;;
esac
