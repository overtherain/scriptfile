#!/bin/bash
files=`ls *.apk | xargs -n 1`
ls *.apk | xargs -n 1 apktool d -f
find . -name AndroidManifest.xml | xargs -n 1 head | grep 'package='
echo $files
