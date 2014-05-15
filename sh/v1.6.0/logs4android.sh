#!/bin/bash
#1.6.0
function inc()
{
	((num++))
}

function init()
{
	inc
	echo "==============${num}. =============init"
	# prepare adb connection
	java -version
	#adb kill-server
	# this will cause adb reconnect
	adb root
	sleep 2
	adb "wait-for-device"
	adb devices
	echo "- device connected!"
	echo "- record log version"
	getproplog
	createOldfold
	getOldlog
	counter=0
	gpslog
}

function getproplog()
{
	inc
	echo "==============${num}. =============getproplog"
	# check ro.build.type
	type=`adb shell getprop ro.build.type`
	echo ${type}
	type=${type%%\?*}
	ttype=`echo $type | tr -d "[\r]"`
	#| grep -r "\[ro.build.type\]" > `pwd`/tmp/ro.build.type.txt

	# check ro.product.board
	board=`adb shell getprop ro.product.board`
	#| grep -r "\[ro.product.board\]" > `pwd`/tmp/ro.product.board.txt
	echo $board
	board=${board%%\?*}
	tboard=`echo $board | tr -d "[\r]"`

	# check ro.build.version.release
	androidVer=`adb shell getprop ro.build.version.release`
	#| grep -r "\[ro.build.version.release\]" > `pwd`/tmp/ro.build.version.release.txt
	echo $androidVer
	androidVer=${androidVer%%\?*}
	tandroidVer=`echo $androidVer | tr -d "[\r]"`

	# Set LOGDIR
	#date -d tomorrow +%Y%m%d
	LOGDIR="slog_`date +%Y.%m.%d_%H.%M.%S`_$tboard"_"$ttype"
	echo "save location "${LOGDIR}

	# create some dirs, which need for store log files
	echo "create dirs..."
	target_dir=${LOGDIR}
	top_dir=`pwd`/logs/$target_dir
	mkdir -p $top_dir

	# check ro.build.fingerprint
	echo  "- get ro.build.fingerprint"
	#echo `adb shell getprop ro.build.fingerprint` > "$top_dir/ro.build.fingerprint.txt"
	echo 1.6.0 > "$top_dir/toolsversion.txt"
}

function createOldfold()
{
	inc
	echo "==============${num}. =============createOldfold"
	# create dirs for logs
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
}

function getOldlog()
{
	inc
	echo "==============${num}. =============getOldlog"
	# get dut infomation
	echo  - get DUT information
	adb shell getprop > ${LOGDIR_OLD}/deviceinfo.txt
	adb shell df > ${LOGDIR_OLD}/diskUsageInfo.txt
	case ${btype} in
		user)
			echo  "- skip recorder memoinfo --user"
			;;
		*)
			adb shell free > ${LOGDIR_OLD}/memoryUsageInfo.txt
			;;
	esac
	adb shell top -n 1 > ${LOGDIR_OLD}/processInfo.txt

	# capture old log
	echo  "- app_parts/mmssms.db..."
	adb pull /data/data/com.android.providers.telephony/app_parts ${LOGDIR_OLD}/com.android.providers.telephony 1>NUL 2>NUL
	adb pull /data/data/com.android.providers.telephony/databases/mmssms.db ${LOGDIR_OLD}/com.android.providers.telephony 1>NUL 2>NUL

	echo  "- logs4android..."
	adb pull /sdcard/logs4android/ ${LOGDIR_OLD}/logs4android 1>NUL 2>NUL

	echo  "- logs4modem..."
	adb pull /sdcard/logs4modem/ ${LOGDIR_OLD}/logs4modem 1>NUL 2>NUL

	echo  "- anr trace..."
	adb pull /data/anr/ ${LOGDIR_OLD}\anr 1>NUL 2>NUL

	echo  "- tombstones..."
	adb pull /data/tombstones ${LOGDIR_OLD}/tombstones 1>NUL 2>NUL

	echo  "- snapshot..."
	case ${btype} in
		user)
			java -jar %cd%\tools\Screenshot.jar ${LOGDIR_OLD}/snapshot.png 1>NUL 2>NUL
			;;
		*)
			adb shell gsnap snapshot.png /dev/graphics/fb0 1>NUL 2>NUL
			adb pull /snapshot.png ${LOGDIR_OLD} 1>NUL 2>NUL
			;;
	esac

	echo  "- apanic..."
	adb pull /data/dontpanic/apanic_console ${LOGDIR_OLD}/apanic 1>NUL 2>NUL
	adb pull /data/dontpanic/apanic_threads ${LOGDIR_OLD}/apanic 1>NUL 2>NUL

	echo  "- hprofs/*..."
	adb pull /data/misc/hprofs/* ${LOGDIR_OLD}/hprofs/ 1>NUL 2>NUL
}

function gpslog()
{
	inc
	echo "==============${num}. =============gpslog"
	case ${androidVer} in
		2.3.5)
			adb pull /data/sirf_interface_log.txt ${LOGDIR_OLD}\gps
			adb pull /data/DetailedLog.txt ${LOGDIR_OLD}\gps
			adb pull /data/BriefLog.txt ${LOGDIR_OLD}\gps
			adb pull /data/A-GPS.LOG ${LOGDIR_OLD}\gps
			adb pull /data/nav.gps ${LOGDIR_OLD}\gps
			getNVMLog1
			;;
		*)
			btlog
			;;
	esac
}

function btlog()
{
	inc
	echo "==============${num}. =============btlog"
	echo  "- bt log"
	adb pull /data/hcidump_bt.cfa ${LOGDIR_OLD}\bt

	case ${btype} in
		user)
			echo  "- skip deleting old log files"
			next
			;;
		*)
			echo  "- deleting old log files..."
			adb shell rm -rf /data/tombstones 1>NUL 2>NUL
			adb shell rm -rf /data/dontpanic/ 1>NUL 2>NUL
			adb shell rm -rf /data/anr/ 1>NUL 2>NUL
			adb shell rm -rf /data/misc/hprofs/ 1>NUL 2>NUL
			adb shell rm -rf /data/hcidump_bt.cfa 1>NUL 2>NUL
			;;
	esac
}

function getNVMLog1()
{
	inc
	echo "==============${num}. =============getNVMLog1"
	adb pull /data/NVM${counter} ${LOGDIR_OLD}/gps
	echo pull NVM ${counter}
	((counter++))
	if (( counter <= 50 )); then
		getNVMLog1
	fi
	btlog
}

function next()
{
	inc
	echo "==============${num}. =============next"
	# start logging various android log
	adb shell setprop log.tag.Mms:transaction VERBOSE
	adb logcat -v threadtime >${LOGDIR}/logcat_main.log
	adb logcat -b radio -v threadtime  >${LOGDIR}/logcat_radio.log
	case ${btype} in
		user)
			echo  "- skip capture kmsg tcpdump and hcidump logs"
			;;
		*)
			adb shell cat /proc/kmsg  >${LOGDIR}/kmsg.log
			adb shell tcpdump -i any -p -s 0 -w /sdcard/capture.pcap
			wifilog
			;;
	esac
	end
}

function wifilog()
{
	inc
	echo "==============${num}. =============wifilog"
	# new add wifi log
	case ${androidVer} in
		4.0.3)
			# adb shell hcidump -Xt >${LOGDIR}/hcidump.log
			adb shell hcidump -w /data/hcidump_bt.cfa
			;;
		*)
			# adb shell hcidump -XVt >${LOGDIR}/hcidump.log
			adb shell hcidump --btsnoop -w /data/hcidump_bt.cfa
			;;
	esac
}

function end()
{
	inc
	echo "==============${num}. =============end"
	echo "\
	********************************************************
	Start logging the Android device into:
	   ${LOGDIR}
	.
	 *********************************************
		PC system is : `lsb_release -a`
		PC kernel is : `uname -a`
		DUT android version is : ${androidVer}
		DUT product.board is : ${board}
		DUT build.type is : ${btype}
	 *********************************************
	  Process running on background!!!
	  This process will be killed after running StopLogging.sh
		 !!! Don't close this window mannually !!!
	********************************************************"
}

function notdo()
{
	mkdir $top_dir/internal_storage
	mkdir $top_dir/external_storage
	mkdir -p $top_dir/external_storage/dropbox
	mkdir -p $top_dir/external_storage/hprofs

	# if external_storage and external_storage is full then log store in data/slog/
	internal_log_dir=`adb shell slogctl query | grep "^internal" | cut -d',' -f2`
	external_log_dir=`adb shell slogctl query | grep "^external" | cut -d',' -f2`

	echo "capture logs..."
	adb shell slogctl screen
	adb shell slogctl snap
	adb shell slogctl snap bugreport

	echo " - get dropbox and hprofs"
	adb pull /data/system/dropbox $top_dir/external_storage/dropbox
	adb pull /data/misc/hprofs $top_dir/external_storage/hprofs

	echo "dump logs..."
	cd $top_dir/internal_storage
	adb pull $internal_log_dir
	cd $top_dir/external_storage
	adb pull $external_log_dir

	echo "- clear log files"
	adb shell slogctl clear
}
num=0
init
