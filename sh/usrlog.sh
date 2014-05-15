#!/bin/bash
read -p "Input log number:" num;
if [ -n num ]; then
	echo "num:${num}";
else
	num="01";
fi
adb logcat -c
adb logcat -v threadtime > logcat_main${zipstr}${num}.log | tail -f logcat_main${zipstr}${num}.log
#echo logcat_main${zipstr}${num}.log
