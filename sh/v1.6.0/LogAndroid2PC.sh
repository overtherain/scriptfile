#!/bin/bash

## V1.6.0
echo - env
java -version
echo  - checking connection...
# adb kill-server
adb root
adb wait-for-device
adb devices
echo  - device connected.

lsb_release -a
uname -a

adb shell getprop | find "[ro.build.type]" > ${PWD}/tmp/ro.build.type.txt
adb shell getprop | find "[ro.product.board]" > ${PWD}/tmp/ro.product.board.txt
adb shell getprop | find "[ro.build.version.release]" > ${PWD}/tmp/ro.build.version.release.txt

# wait for 3 seconds
@ping 127.0.0.1 -n 2 > NUL

type=`adb shell getprop ro.build.type`
echo $type
type=${type%%\?*}
ttype=`echo $type | tr -d "[\r]"`
#| grep -r "\[ro.build.type\]" > `pwd`/tmp/ro.build.type.txt

board=`adb shell getprop ro.product.board`
#| grep -r "\[ro.product.board\]" > `pwd`/tmp/ro.product.board.txt
echo $board
board=${board%%\?*}
tboard=`echo $board | tr -d "[\r]"`

androidVer=`adb shell getprop ro.build.version.release`
#| grep -r "\[ro.build.version.release\]" > `pwd`/tmp/ro.build.version.release.txt
echo $androidVer
androidVer=${androidVer%%\?*}
tandroidVer=`echo $androidVer | tr -d "[\r]"`

#date -d tomorrow +%Y%m%d
LOGDIR="slog_`date +%Y.%m.%d_%H.%M.%S`_$tboard"_"$ttype"
echo "save location "$LOGDIR

echo "create dirs..."
target_dir=$LOGDIR
top_dir=`pwd`/logs/$target_dir
mkdir -p $top_dir
echo  "- get ro.build.fingerprint"
#echo `adb shell getprop ro.build.fingerprint` > "$top_dir/ro.build.fingerprint.txt"
echo 1.6.0 > "$top_dir/toolsversion.txt"



LOGDIR=${PWD}/logs/${LOGDIR}
LOGDIR=${LOGDIR}_%board%_%btype%
echo ${LOGDIR} > ${PWD}/tmp/~testing
LOGDIR="${LOGDIR}"
mkdir ${LOGDIR} 1>NUL 2>NUL



echo $btype

# we don't need logs4andriod running on the DUT
# adb shell stop logs4android

# backup the old logs before capture log
LOGDIR_OLD=${LOGDIR}/old_log
mkdir ${LOGDIR_OLD}
mkdir ${LOGDIR_OLD}/apanic
mkdir ${LOGDIR_OLD}/anr
mkdir ${LOGDIR_OLD}/hprofs
mkdir ${LOGDIR_OLD}/com.android.providers.telephony
mkdir ${LOGDIR_OLD}/logs4android
mkdir ${LOGDIR_OLD}/logs4modem
mkdir ${LOGDIR_OLD}/bt
mkdir ${LOGDIR_OLD}/gps

echo  - get DUT information
adb shell getprop > ${LOGDIR_OLD}/deviceinfo.txt
adb shell df > ${LOGDIR_OLD}/diskUsageInfo.txt

case $btype in
	user)
		echo  - skip recorder memoinfo --user
		break;;
	*)
		adb shell free > ${LOGDIR_OLD}/memoryUsageInfo.txt
		break;;
esac

adb shell top -n 1 > ${LOGDIR_OLD}/processInfo.txt

# capture old log
echo  - app_parts/mmssms.db...
adb pull /data/data/com.android.providers.telephony/app_parts ${LOGDIR_OLD}/com.android.providers.telephony 1>NUL 2>NUL
adb pull /data/data/com.android.providers.telephony/databases/mmssms.db ${LOGDIR_OLD}/com.android.providers.telephony 1>NUL 2>NUL

echo  - logs4android...
adb pull /sdcard/logs4android/ ${LOGDIR_OLD}/logs4android 1>NUL 2>NUL

echo  - logs4modem...
adb pull /sdcard/logs4modem/ ${LOGDIR_OLD}/logs4modem 1>NUL 2>NUL

echo  - anr trace...
adb pull /data/anr/ ${LOGDIR_OLD}/anr 1>NUL 2>NUL

echo  - tombstones...
adb pull /data/tombstones ${LOGDIR_OLD}/tombstones 1>NUL 2>NUL

echo  - snapshot...
case $btype in
	user)
		java -jar ${PWD}/tools/Screenshot.jar ${LOGDIR_OLD}/snapshot.png 1>NUL 2>NUL
		break;;
	*)
		adb shell gsnap snapshot.png /dev/graphics/fb0 1>NUL 2>NUL
		adb pull /snapshot.png ${LOGDIR_OLD} 1>NUL 2>NUL
		break;;
esac

echo  - apanic...
adb pull /data/dontpanic/apanic_console ${LOGDIR_OLD}/apanic 1>NUL 2>NUL
adb pull /data/dontpanic/apanic_threads ${LOGDIR_OLD}/apanic 1>NUL 2>NUL

echo  - hprofs/*...
adb pull /data/misc/hprofs/* ${LOGDIR_OLD}/hprofs/ 1>NUL 2>NUL

if {%androidVer%}=={2.3.5} (
adb pull /data/sirf_interface_log.txt ${LOGDIR_OLD}/gps
adb pull /data/DetailedLog.txt ${LOGDIR_OLD}/gps
adb pull /data/BriefLog.txt ${LOGDIR_OLD}/gps
adb pull /data/A-GPS.LOG ${LOGDIR_OLD}/gps
adb pull /data/nav.gps ${LOGDIR_OLD}/gps
goto :getNVMLog1
) else (
goto :bt
)

/a counter=0
:getNVMLog1
adb pull /data/NVM%counter% ${LOGDIR_OLD}/gps
echo pull NVM %counter%
/a counter=%counter%+1
if %counter% lss 50 goto :getNVMLog1

:bt
echo  - bt log
adb pull /data/hcidump_bt.cfa ${LOGDIR_OLD}/bt

case $btype in
	user)
		echo  - skip deleting old log files
goto :next
) else (
echo  - deleting old log files...
adb shell rm -rf /data/tombstones 1>NUL 2>NUL
adb shell rm -rf /data/dontpanic/ 1>NUL 2>NUL
adb shell rm -rf /data/anr/ 1>NUL 2>NUL
adb shell rm -rf /data/misc/hprofs/ 1>NUL 2>NUL
adb shell rm -rf /data/hcidump_bt.cfa 1>NUL 2>NUL
)

next()
{
# start logging various android log
adb shell setprop log.tag.Mms:transaction VERBOSE &
adb logcat -v threadtime >${LOGDIR}/logcat_main.log &
adb logcat -b radio -v threadtime  >${LOGDIR}/logcat_radio.log &

case $btype in
	user)
		echo  - skip capture kmsg tcpdump and hcidump logs
		break;;
	*)
		adb shell cat /proc/kmsg  >${LOGDIR}/kmsg.log &
		adb shell tcpdump -i any -p -s 0 -w /sdcard/capture.pcap &
		break;;
esac

# new add wifi log
case ${androidVer} in
	4.0.3)
		## adb shell hcidump -Xt >${LOGDIR}/hcidump.log
		adb shell hcidump -w /data/hcidump_bt.cfa &
		break;;
	*)
		## adb shell hcidump -XVt >${LOGDIR}/hcidump.log
		adb shell hcidump --btsnoop -w /data/hcidump_bt.cfa &
		break;;
esac


:exception
echo press any key to exit!
pause
exit
