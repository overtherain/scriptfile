#!/bin/bash
adb shell cat /proc/kmsg > kmsg_gdz_`date +%Y%m%d_%H%M`.log
