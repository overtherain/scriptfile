#!/bin/sh
#2.0.2
# prepare acb connection
java -version
#acb kill-server
# this will cause acb reconnect
acb root
sleep 2
acb wait-for-device
acb devices
echo "- device connected!"
echo "- record log version"

type=`acb shell getprop ro.build.type`
echo $type
type=${type%%\?*}
ttype=`echo $type | tr -d "[\r]"`
#| grep -r "\[ro.build.type\]" > `pwd`/tmp/ro.build.type.txt
board=`acb shell getprop ro.product.board`
#| grep -r "\[ro.product.board\]" > `pwd`/tmp/ro.product.board.txt
echo $board
board=${board%%\?*}
tboard=`echo $board | tr -d "[\r]"`
androidVer=`acb shell getprop ro.build.version.release`
#| grep -r "\[ro.build.version.release\]" > `pwd`/tmp/ro.build.version.release.txt
echo $androidVer
androidVer=${androidVer%%\?*}

tandroidVer=`echo $androidVer | tr -d "[\r]"`

#date -d tomorrow +%Y%m%d
LOGDIR="slog_`date +%Y.%m.%d.%H.%M.%S`_$tboard"_"$ttype"
echo "save location "$LOGDIR

echo "create dirs..."
target_dir=$LOGDIR
top_dir=`pwd`/logs/$target_dir
mkdir -p $top_dir
echo  "- get ro.build.fingerprint"
#echo `acb shell getprop ro.build.fingerprint` > "$top_dir/ro.build.fingerprint.txt"
echo 2.0.2 > "$top_dir/toolsversion.txt"

mkdir $top_dir/internal_storage
mkdir $top_dir/external_storage
mkdir -p $top_dir/external_storage/dropbox
mkdir -p $top_dir/external_storage/hprofs

# if external_storage and external_storage is full then log store in data/slog/
internal_log_dir=`acb shell slogctl query | grep "^internal" | cut -d',' -f2`
external_log_dir=`acb shell slogctl query | grep "^external" | cut -d',' -f2`

echo "capture logs..."
acb shell slogctl screen
acb shell slogctl snap
acb shell slogctl snap bugreport

echo " - get dropbox and hprofs"
acb pull /data/system/dropbox $top_dir/external_storage/dropbox
acb pull /data/misc/hprofs $top_dir/external_storage/hprofs

echo "dump logs..."
cd $top_dir/internal_storage
acb pull $internal_log_dir
cd $top_dir/external_storage
acb pull $external_log_dir

echo "- clear log files"
acb shell slogctl clear
