#!/bin/bash
VERSION=2.3.3
# add configitems
backup=0
dotbackup=0
profile=0
blacklist=0
bt_prefs=0
bt_bluetooth=0
bt_misc=0
bt_miscd=0
contacts=0
dm=0
fileexplorer=0
homescreen_launcher2=0
homescreen_launcher3=0
homescreen_sprd_launcher2=0
homescreen_sprd_launcher3=0
packageinstall=0
phone_telephony=0
phone_contacts=0
settings=0
wifi=0
## self.define
TOOLSDIR=$1
echo tools.dir ist ${TOOLSDIR}
TAG="[slog@${VERSION}]: "
#### self.define
CURDIR=`pwd`
echo current ist ${CURDIR}
WHOAMI=`whoami`
echo ${TAG} tools.dir ist ${TOOLSDIR}
# create log path for  store the latest log store path
latest_log_path="${TOOLSDIR}/tmp/latest_log_path"
# create folder store runtime logs
BASEDIR=slog_`date +%Y%m%d%H%M%S`
LOG=${TOOLSDIR}/logs/$BASEDIR
LOGFILE=$LOG"runtimelogs.log"
echo ${TAG} log.dir ist ${LOG}
touch $LOGFILE 2>&1|tee -a $LOGFILE

echo "- begin capture log at `date`" 2>&1|tee -a $LOGFILE
# prepare adb connection
echo "version:$VERSION" 2>&1|tee -a $LOGFILE
echo `uname` 2>&1|tee -a $LOGFILE
java -version 2>&1|tee -a $LOGFILE
#adb kill-server
# this will cause adb reconnect
adb devices 2>&1|tee -a $LOGFILE
sleep 5
adb wait-for-device
echo "- device connected!" 2>&1|tee -a $LOGFILE
echo "- record log version" 2>&1|tee -a $LOGFILE
type=`adb shell getprop  ro.build.type` 
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
androidVer=`adb shell getprop  ro.build.version.release 2>&1|tee -a $LOGFILE`
#grep -r "\[ro.build.version.release\]" > `pwd`/tmp/ro.build.version.release.txt
echo $androidVer 2>&1|tee -a $LOGFILE
androidVer=${androidVer%%\?*}

tandroidVer=`echo $androidVer | tr -d "[\r]" 2>&1|tee -a $LOGFILE`

#date -d tomorrow +%Y%m%d
LOGDIR=$BASEDIR"_"$tboard"_"$ttype
## slog_20150107174258_slog@2.3.3: sp7731gea_slog@2.3.3: userdebug
echo ${TAG} ${LOGDIR}
echo "save location "$LOGDIR 2>&1|tee -a $LOGFILE

echo ${TAG} "create dirs..."
target_dir=$LOGDIR
base_dir=${TOOLSDIR}
top_dir=${TOOLSDIR}/logs/$target_dir
echo top_dir ${top_dir}
mkdir -p $top_dir

# store log path to file 
echo $top_dir>$latest_log_path
echo ${TAG} top_dir ist $top_dir

echo "- get ro.build.fingerprint" 2>&1|tee -a $LOGFILE
adb shell getprop  ro.build.fingerprint > "$top_dir/ro.build.fingerprint.txt"
adb shell getprop  dev.bootcomplete >> "$top_dir/deviceinfo.txt"
adb shell getprop  init.svc.fuse_tempsd >> "$top_dir/deviceinfo.txt"
adb shell getprop  init.svc.sdcard >> "$top_dir/deviceinfo.txt"
adb shell getprop  init.svc.watchdogd >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.board.platform >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.build.date >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.build.host >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.build.user >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.build.version.sdk >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.hardware >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.product.hardware >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.product.model >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.product.name >> "$top_dir/deviceinfo.txt"
adb shell getprop  ro.runtime.firstboot >> "$top_dir/deviceinfo.txt"
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
mkdir -p $top_dir/media
mkdir -p $top_dir/contact
mkdir -p $top_dir/ffosdatabase
# add app logs
mkdir -p $top_dir/app

# add check orign file exist

# if external_storage and external_storage is full then log store in data/slog/
internal_log_dir=`adb shell slogctl query |grep "internal" | cut -d',' -f2 2>&1|tee -a $LOGFILE`
external_log_dir=`adb shell slogctl query |grep "external" | cut -d',' -f2 2>&1|tee -a $LOGFILE`

echo "get external path" 2>&1|tee -a $LOGFILE
external_sdcard=`echo ${TAG} $external_log_dir | sed 's/\/slog//g' 2>&1|tee -a $LOGFILE`

echo ${TAG} "external path is $external_sdcard internal_log_dir is $internal_log_dir"

echo "capture logs..." 2>&1|tee -a $LOGFILE
adb shell slogctl screen 2>&1|tee -a $LOGFILE
adb shell slogctl snap 2>&1|tee -a $LOGFILE

echo " - get dropbox hprofs corefile" 2>&1|tee -a $LOGFILE
adb pull /data/system/dropbox $top_dir/dropbox 2>&1|tee -a $LOGFILE
adb pull /data/misc/hprofs $top_dir/hprofs 2>&1|tee -a $LOGFILE
adb pull  /data/corefile $top_dir/corefile 2>&1|tee -a $LOGFILE
adb pull /data/data/com.android.providers.telephony/databases/ $top_dir/mms 2>&1|tee -a $LOGFILE
adb pull /data/data/com.android.providers.media/databases/ $top_dir/media 2>&1|tee -a $LOGFILE
adb pull /data/data/com.android.providers.contacts/databases/ $top_dir/contact 2>&1|tee -a $LOGFILE

echo " - get app data" 2>&1|tee -a $LOGFILE
if [ "$backup" == "1" ];then
mkdir -p $top_dir/app/backup
adb pull  $external_log_dir/backup   $top_dir/app/backup 2>&1|tee -a $LOGFILE
fi
if [ "$dotbackup" == "1" ];then
mkdir -p $top_dir/app/dotbackup
adb pull  $external_log_dir/.backup   $top_dir/app/dotbackup 2>&1|tee -a $LOGFILE
fi
if [ "$profile" == "1" ];then
mkdir -p $top_dir/app/profile
adb pull  /data/data/com.sprd.audioprofile/   $top_dir/app/profile 2>&1|tee -a $LOGFILE
fi
if [ "$blacklist" == "1" ];then
mkdir -p $top_dir/app/blacklist
adb pull  /data/data/com.sprd.firewall/   $top_dir/app/blacklist 2>&1|tee -a $LOGFILE
fi
if [ "$bt_prefs" == "1" ];then
mkdir -p $top_dir/app/bt-prefs
adb pull  /data/data/com.android.settings/shared_prefs  $top_dir/app/bt-prefs 2>&1|tee -a $LOGFILE
fi
if [ "$bt_bluetooth" == "1" ];then
mkdir -p $top_dir/app/bt-bluetooth
adb pull  /data/data/com.android.bluetooth  $top_dir/app/bt-bluetooth 2>&1|tee -a $LOGFILE
fi
if [ "$bt_misc" == "1" ];then
mkdir -p $top_dir/app/bt-misc
adb pull  /data/misc/bluetooth/  $top_dir/app/bt-misc 2>&1|tee -a $LOGFILE
fi
if [ "$bt_miscd" == "1" ];then
mkdir -p $top_dir/app/bt-miscd
adb pull  /data/misc/bluetoothd/  $top_dir/app/bt-miscd 2>&1|tee -a $LOGFILE
fi
if [ "$contacts" == "1" ];then
mkdir -p $top_dir/app/contacts
adb pull   /data/data/com.android.providers.contacts  $top_dir/app/contacts 2>&1|tee -a $LOGFILE
fi
if [ "$dm" == "1" ];then
mkdir -p $top_dir/app/dm
adb pull   /data/data/com.android.providers.telephony/databases/telephony.db  $top_dir/app/dm 2>&1|tee -a $LOGFILE
fi
if [ "$fileexplorer" == "1" ];then
mkdir -p $top_dir/app/fileexplorer
adb pull   /data/data/com.android.providers.media/databases/  $top_dir/app/fileexplorer 2>&1|tee -a $LOGFILE
fi
if [ "$homescreen_launcher2" == "1" ];then
mkdir -p $top_dir/app/homescreen-launcher2
adb pull   /data/data/com.android.launcher2/  $top_dir/app/homescreen-launcher2 2>&1|tee -a $LOGFILE
fi
if [ "$homescreen_launcher3" == "1" ];then
mkdir -p $top_dir/app/homescreen-launcher3
adb pull   /data/data/com.android.launcher3/  $top_dir/app/homescreen-launcher3 2>&1|tee -a $LOGFILE
fi
if [ "$homescreen_sprd_launcher2" == "1" ];then
mkdir -p $top_dir/app/homescreen-sprd-launcher2
adb pull   /data/data/com.android.launcher2/  $top_dir/app/homescreen-sprd-launcher2 2>&1|tee -a $LOGFILE
fi
if [ "$homescreen_sprd_launcher3" == "1" ];then
mkdir -p $top_dir/app/homescreen-sprd-launcher3
adb pull   /data/data/com.android.sprdlauncher3/  $top_dir/app/homescreen-sprd-launcher3 2>&1|tee -a $LOGFILE
fi
if [ "$packageinstall" == "1" ];then
mkdir -p $top_dir/app/packageinstall
adb pull   /data/system/packages.xml  $top_dir/app/packageinstall 2>&1|tee -a $LOGFILE
fi
if [ "$phone_telephony" == "1" ];then
mkdir -p $top_dir/app/phone-telephony
adb pull   /data/data/com.android.providers.telephony  $top_dir/app/phone-telephony 2>&1|tee -a $LOGFILE
fi
if [ "$phone_contacts" == "1" ];then
mkdir -p $top_dir/app/phone-contacts
adb pull   /data/data/com.android.providers.contacts  $top_dir/app/phone-contacts 2>&1|tee -a $LOGFILE
fi
if [ "$settings" == "1" ];then
mkdir -p $top_dir/app/settings
adb pull   /data/data/com.android.providers.settings/ $top_dir/app/settings 2>&1|tee -a $LOGFILE
fi
if [ "$wifi" == "1" ];then
mkdir -p $top_dir/app/wifi
adb pull   /data/misc/wifi/  $top_dir/app/wifi 2>&1|tee -a $LOGFILE
fi

echo "- get ffos mms sms contact call_log database" 2>&1|tee -a $LOGFILE
adb pull /data/local/storage/persistent/chrome/idb  $top_dir/ffosdatabase 2>&1|tee -a $LOGFILE

echo "- get modem_memory log..." 2>&1|tee -a $LOGFILE
adb pull /sdcard/modem_memory.log $top_dir/internal_storage/ 2>&1|tee -a $LOGFILE
adb pull /sdcard/external/modem_memory.log $top_dir/external_storage/ 2>&1|tee -a $LOGFILE

echo "dump internal slogs... `date`" 2>&1|tee -a $LOGFILE
cd $top_dir/internal_storage
echo adb pull $internal_log_dir 2>&1|tee -a $LOGFILE
adb pull $internal_log_dir 2>&1|tee -a $LOGFILE
echo "dump external slogs... `date`" 2>&1|tee -a $LOGFILE
cd $top_dir/external_storage
echo adb pull $external_log_dir 2>&1|tee -a $LOGFILE
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
     echo "- clear slog `date`" 2>&1|tee -a $LOGFILE
     adb shell slogctl clear 2>&1|tee -a $LOGFILE
fi

echo "- get kernel panic core file begin at `date`" 2>&1|tee -a $LOGFILE
#adb shell rm -r $external_sdcard/sysdump/* 2>&1|tee -a $LOGFILE
adb shell mkdir $external_sdcard/sysdump/ 2>&1|tee -a $LOGFILE
adb shell mv $external_sdcard/sysdump.core*  $external_sdcard/sysdump/ 2>&1|tee -a $LOGFILE
adb pull $external_sdcard/sysdump $top_dir/sysdump 2>&1|tee -a $LOGFILE
echo "- get kernel panic core file finished at `date`" 2>&1|tee -a $LOGFILE

echo "- get Trout BT log...`date`" 2>&1|tee -a $LOGFILE
adb shell echo ${TAG} 1 > /sys/kernel/trout_debug/trout_btdebug_cmd 2>&1|tee -a $LOGFILE
adb pull /data/bt_regsdata.txt $top_dir/bt_reg/ 2>&1|tee -a $LOGFILE

echo "- get Trout WiFi log..." 2>&1|tee -a $LOGFILE
adb shell iwconfig wlan0 trout_dbg 2 2>&1|tee -a $LOGFILE
adb shell iwconfig wlan0 trout_dbg 8 2>&1|tee -a $LOGFILE
adb pull /data/allregs.txt $top_dir/wifi_reg/ 2>&1|tee -a $LOGFILE

# adapter iwconfig and trw command
echo "- check iwconfig execute ok or N" 2>&1|tee -a $LOGFILE
if [ ! -f $top_dir/wifi_reg/allregs.txt ];then
adb shell trw get legacy 2 2>&1|tee -a $LOGFILE
adb shell trw get legacy 8 2>&1|tee -a $LOGFILE
adb pull /data/allregs.txt $top_dir/wifi_reg/ 2>&1|tee -a $LOGFILE
fi

echo "- NMEA about log" 2>&1|tee -a $LOGFILE
adb pull  /data/cg/online $top_dir/cg 2>&1|tee -a $LOGFILE

#echo ${TAG} "- clear core file" 2>&1|tee -a $LOGFILE
#files=`ls $top_dir/sysdump`
#if [ -z "$files" ]; then
#     echo ${TAG} "Folder $top_dir/sysdump is empty!" 2>&1|tee -a $LOGFILE
#else
#     adb shell rm -r $external_sdcard/sysdump/* 2>&1|tee -a $LOGFILE
#fi


#for support 8825 4.1 4 cores
#files=`ls $top_dir/corefile`
#if [ -z "$files" ]; then
#     echo ${TAG} "Folder $top_dir/corefile is empty!" 2>&1|tee -a $LOGFILE
#else
#     adb shell rm -r /data/corefile/* 2>&1|tee -a $LOGFILE
#fi


#ffos crash report dump files
DMPDIR=/data/b2g/mozilla
mkdir -p $top_dir/ffos
adb shell busybox find $DMPDIR -name "*.dmp" -o -name "*.extra" | sed 's/\r//'| while read file
do
    adb pull "$file" $top_dir/ffos/ 2>&1|tee -a $LOGFILE
done

echo "- get bt logs for-android  4.1_3.4" 2>&1|tee -a $LOGFILE
mkdir -p $top_dir/bt
adb pull /sdcard/btsnoop_hci.log $top_dir/bt/ 2>&1|tee -a $LOGFILE
echo "- capture log finished at `date`" 2>&1|tee -a $LOGFILE
echo " check logs"
cd $base_dir
cd ${CURDIR}
echo ${TAG} python logCheck.py $top_dir 2>&1|tee -a $LOGFILE
python logCheck.py $top_dir 2>&1|tee -a $LOGFILE
echo ${TAG} python genDir.py  $top_dir 2>&1|tee -a $LOGFILE
python genDir.py  $top_dir 2>&1|tee -a $LOGFILE
