#!/bin/bash
adb shell "tcpdump -i any -p -s 0 -w /data/local/tmp/capture.cap"
adb pull /data/local/tmp/capture.cap

