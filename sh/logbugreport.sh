#!/bin/bash
fold="bugreport.${datestr}"
echo "fold:$fold"
mkdir -p "./${fold}"
cd $fold
adb shell bugreport > bugreport.log
