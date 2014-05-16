#!/bin/bash
VERSION=2.2.4
# create log path for  store the latest log store path
latest_log_path="`pwd`/tmp/latest_log_path"
# create folder store runtime logs
BASEDIR=slog_`date +%Y%m%d%H%M%S`
LOG=`pwd`/logs/$BASEDIR
LOGFILE=$LOG"runtimelogs.log"
touch $LOGFILE 2>&1|tee -a $LOGFILE

# prepare adb connection
echo "version:$VERSION" 2>&1|tee -a $LOGFILE
java -version 2>&1|tee -a $LOGFILE
#adb kill-server
# this will cause adb reconnect
adb devices 2>&1|tee -a $LOGFILE
sleep 2
adb wait-for-device
echo "- device connected!" 2>&1|tee -a $LOGFILE
echo "- record log version" 2>&1|tee -a $LOGFILE
type=`adb shell getprop ro.build.type` 
echo $type 2>&1|tee -a $LOGFILE
type=${type%%\?*}
ttype=`echo $type | tr -d "[\r]"`
if [ "$ttype" == "user" ];then
echo "- user version" 2>&1|tee -a $LOGFILE
else
adb root 2>&1|tee -a $LOGFILE
adb wait-for-device
sleep 5
fi
#grep -r "\[ro.build.type\]" > `pwd`/tmp/ro.build.type.txt
board=`adb shell getprop ro.product.board  2>&1|tee -a $LOGFILE`
#grep -r "\[ro.product.board\]" > `pwd`/tmp/ro.product.board.txt
echo $board 2>&1|tee -a $LOGFILE
board=${board%%\?*}
tboard=`echo $board | tr -d "[\r]" 2>&1|tee -a $LOGFILE`
androidVer=`adb shell getprop ro.build.version.release 2>&1|tee -a $LOGFILE`
#grep -r "\[ro.build.version.release\]" > `pwd`/tmp/ro.build.version.release.txt
echo $androidVer 2>&1|tee -a $LOGFILE
androidVer=${androidVer%%\?*}

tandroidVer=`echo $androidVer | tr -d "[\r]" 2>&1|tee -a $LOGFILE`

#date -d tomorrow +%Y%m%d
LOGDIR=$BASEDIR"_"$tboard"_"$ttype
echo "save location "$LOGDIR 2>&1|tee -a $LOGFILE

echo "create dirs..."
target_dir=$LOGDIR
top_dir=`pwd`/logs/$target_dir
mkdir -p $top_dir

# store log path to file 
echo $top_dir>$latest_log_path

echo  "- get ro.build.fingerprint" 2>&1|tee -a $LOGFILE
#echo `adb shell getprop ro.build.fingerprint` > "$top_dir/ro.build.fingerprint.txt"
echo $VERSION > "$top_dir/toolsversion.txt" 2>&1|tee -a $LOGFILE

mkdir $top_dir/internal_storage
mkdir $top_dir/external_storage
mkdir -p $top_dir/dropbox
mkdir -p $top_dir/hprofs
mkdir -p $top_dir/mms
mkdir -p $top_dir/corefile
mkdir -p $top_dir/audio
mkdir -p $top_dir/sysdump
mkdir -p $top_dir/bt_reg
mkdir -p $top_dir/wifi_reg
mkdir -p $top_dir/cg
mkdir -p $top_dir/bugreport
mkdir -p $top_dir/media

# if external_storage and external_storage is full then log store in data/slog/
internal_log_dir=`adb shell slogctl query | grep "^internal" | cut -d',' -f2 2>&1|tee -a $LOGFILE`
external_log_dir=`adb shell slogctl query | grep "^external" | cut -d',' -f2 2>&1|tee -a $LOGFILE`

echo "get external path" 2>&1|tee -a $LOGFILE
external_sdcard=`echo $external_log_dir | sed 's/\/slog//g' 2>&1|tee -a $LOGFILE`

echo "capture logs..." 2>&1|tee -a $LOGFILE
adb shell slogctl screen 2>&1|tee -a $LOGFILE
adb shell slogctl snap 2>&1|tee -a $LOGFILE

echo " - get dropbox hprofs corefile" 2>&1|tee -a $LOGFILE
adb pull /data/system/dropbox $top_dir/dropbox 2>&1|tee -a $LOGFILE
adb pull /data/misc/hprofs $top_dir/hprofs 2>&1|tee -a $LOGFILE
adb pull  /data/corefile $top_dir/corefile 2>&1|tee -a $LOGFILE
adb pull /data/data/com.android.providers.telephony/ $top_dir/mms 2>&1|tee -a $LOGFILE
adb pull /data/data/com.android.providers.media/databases/ $top_dir/media 2>&1|tee -a $LOGFILE

echo  "- get modem_memory log..." 2>&1|tee -a $LOGFILE
adb pull /sdcard/modem_memory.log $top_dir/internal_storage/ 2>&1|tee -a $LOGFILE
adb pull /sdcard/external/modem_memory.log $top_dir/external_storage/ 2>&1|tee -a $LOGFILE

echo "dump logs..." 2>&1|tee -a $LOGFILE
cd $top_dir/internal_storage
adb pull $internal_log_dir 2>&1|tee -a $LOGFILE
cd $top_dir/external_storage
adb pull $external_log_dir 2>&1|tee -a $LOGFILE

echo "- get audio log files" 2>&1|tee -a $LOGFILE
for i in {1..10};
do
adb shell cat /proc/asound/sprdphone/vbc > $top_dir/audio/vbc-$i 2>&1|tee -a $LOGFILE
done
adb pull /proc/asound/sprdphone/sprd-codec $top_dir/audio 2>&1|tee -a $LOGFILE
adb pull /proc/asound/sprdphone/pcm0p/sub0/status $top_dir/audio 2>&1|tee -a $LOGFILE
adb shell tinymix > $top_dir/audio/tinymix.log 2>&1|tee -a $LOGFILE

echo "- clear log files" 2>&1|tee -a $LOGFILE
files=`ls $top_dir/internal_storage`
if [ -z "$files" ]; then
     echo "Folder $top_dir/internal_storage is empty!" 2>&1|tee -a $LOGFILE
else
     adb shell slogctl clear 2>&1|tee -a $LOGFILE
fi

echo "- get kernel panic core file" 2>&1|tee -a $LOGFILE
adb shell rm -r $external_sdcard/sysdump/* 2>&1|tee -a $LOGFILE
adb shell mkdir $external_sdcard/sysdump/ 2>&1|tee -a $LOGFILE
adb shell mv $external_sdcard/sysdump.core*  $external_sdcard/sysdump/ 2>&1|tee -a $LOGFILE
adb pull $external_sdcard/sysdump $top_dir/sysdump 2>&1|tee -a $LOGFILE

echo "- get Trout BT log..." 2>&1|tee -a $LOGFILE
adb shell echo 1 > /sys/kernel/trout_debug/trout_btdebug_cmd 2>&1|tee -a $LOGFILE
adb pull /data/bt_regsdata.txt $top_dir/bt_reg/ 2>&1|tee -a $LOGFILE

echo "- get Trout WiFi log..." 2>&1|tee -a $LOGFILE
adb shell iwconfig wlan0 trout_dbg 2 2>&1|tee -a $LOGFILE
adb shell iwconfig wlan0 trout_dbg 8 2>&1|tee -a $LOGFILE
adb pull /data/allregs.txt $top_dir/wifi_reg/ 2>&1|tee -a $LOGFILE

# adapter iwconfig and trw command
echo  "- check iwconfig execute ok or N" 2>&1|tee -a $LOGFILE
if [ ! -f $top_dir/wifi_reg/allregs.txt ];then
adb shell trw get legacy 2 2>&1|tee -a $LOGFILE
adb shell trw get legacy 8 2>&1|tee -a $LOGFILE
adb pull /data/allregs.txt $top_dir/wifi_reg/ 2>&1|tee -a $LOGFILE
fi

echo  "- NMEA about log" 2>&1|tee -a $LOGFILE
adb pull  /data/cg/online $top_dir/cg 2>&1|tee -a $LOGFILE

echo "- clear core file" 2>&1|tee -a $LOGFILE
files=`ls $top_dir/sysdump`
if [ -z "$files" ]; then
     echo "Folder $top_dir/sysdump is empty!" 2>&1|tee -a $LOGFILE
else
     adb shell rm -r $external_sdcard/sysdump/* 2>&1|tee -a $LOGFILE
fi


#for support 8825 4.1 4 cores
files=`ls $top_dir/corefile`
if [ -z "$files" ]; then
     echo "Folder $top_dir/corefile is empty!" 2>&1|tee -a $LOGFILE
else
     adb shell rm -r /data/corefile/* 2>&1|tee -a $LOGFILE
fi


#ffos crash report dump files
DMPDIR=/data/b2g/mozilla
mkdir -p $top_dir/ffos
adb shell busybox find $DMPDIR -name "*.dmp" -o -name "*.extra" | sed 's/\r//'| while read file
do
    adb pull "$file" $top_dir/ffos/ 2>&1|tee -a $LOGFILE
done

echo  "- get bt logs for-android  4.1_3.4" 2>&1|tee -a $LOGFILE
mkdir -p $top_dir/bt
adb pull /sdcard/btsnoop_hci.log $top_dir/bt/ 2>&1|tee -a $LOGFILE

echo "- get bugreport info" 2>&1|tee -a $LOGFILE
adb shell bugreport > $top_dir/bugreport/bugreport.log
