#!/bin/bash
echo $1
mdir=$1
ver="$2"
case $ver in
	user)
		ver='user'
		;;
	*)
		ver='userdebug'
		;;
esac
zipstr="${ver}_gdz_`date +%Y.%m.%d_%H%M`"
pDir="${ldownload}"
srcPath="${pDir}/download/"
srcName="$1"
destPath="${pDir}/"
destName="${mdir}_${zipstr}"
echo "src:${srcPath}${srcName}"
echo "dest:${destPath}${destName}"
echo "$srcPath$srcName $destPath$destName"
cp -rvf $srcPath$srcName $destPath$destName
#echo "$destName.zip $destName"
#zip -r1 $destName.zip $destName
