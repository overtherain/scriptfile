::2.3.3
@echo off
echo  - set env
set VERSION=2.3.3

set backup1=0
set dotbackup=0
set profile=0
set blacklist=0
set bt_prefs=0
set bt_bluetooth=0
set bt_misc=0
set bt_miscd=0
set contacts=0
set dm=0
set fileexplorer=0
set homescreen_launcher2=0
set homescreen_launcher3=0
set homescreen_sprd_launcher2=0
set homescreen_sprd_launcher3=0
set packageinstall=0
set phone_telephony=0
set phone_contacts=0
set settings=0
set wifi=0

set base_dir="%cd%"
set latest_log_path="%cd%\tmp\latest_log_path"
set ADB_CMD="%cd%\tools\adb.exe"
set FIND_CMD="%cd%\tools\find.exe"
ver | %FIND_CMD% "5.1" > NUL && set XT=windowsXP
ver | %FIND_CMD% "6.1" > NUL && set XT=windows7
set BASEDIR=slog_%DATE:~0,10%%TIME:~0,8%
if {%XT%}=={windows7} (set BASEDIR=%BASEDIR:/=%) else (set BASEDIR=%BASEDIR:-=%)
set BASEDIR=%BASEDIR::=%
set BASEDIR=%BASEDIR: =%
set LOG=%cd%\logs\%BASEDIR%
set LOGFILE=%LOG%runtimelogs.log

echo  - begin capture log %date% %time%>>%LOGFILE% 2>&1
echo  - version:%VERSION%>>%LOGFILE% 2>&1
echo  - system version %XT%>>%LOGFILE% 2>&1
echo  - check adb connection
rem %ADB_CMD% kill-server
rem %ADB_CMD% root
%ADB_CMD% devices>>%LOGFILE% 2>&1
%ADB_CMD% wait-for-device
echo  - device connected.>>%LOGFILE% 2>&1
echo  - device connected.

echo  - get ro.build.type
echo  - get ro.build.type>>%LOGFILE% 2>&1
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.type]" > "%cd%\tmp\ro.build.type.txt"
for /f "tokens=1,* usebackq delims= " %%i in ("%cd%\tmp\ro.build.type.txt") do set btype=%%j
set btype=%btype:~1,-2%

if {%btype%}=={user} (
echo  - user version>>%LOGFILE% 2>&1
) else (
%ADB_CMD% root>>%LOGFILE% 2>&1
%ADB_CMD% wait-for-device
)

rem win7 date behaves differently..
rem echo get pc system version
echo   - current system version is %XT%
echo %XT%>>%LOGFILE% 2>&1

%ADB_CMD% shell getprop | %FIND_CMD% "[ro.product.board]" > "%cd%\tmp\ro.product.board.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.version.release]" > "%cd%\tmp\ro.build.version.release.txt"

echo  - get ro.product.board>>%LOGFILE% 2>&1
for /f "tokens=1,* usebackq delims= " %%i in ("%cd%\tmp\ro.product.board.txt") do set board=%%j
set board=%board:~1,-2%
rem echo %board%

echo  - get ro.build.version.release>>%LOGFILE% 2>&1
for /f "tokens=1,* usebackq delims= " %%i in ("%cd%\tmp\ro.build.version.release.txt") do set androidVer=%%j
set androidVer=%androidVer:~1,-2%
rem echo %androidVer%

echo  - set log dir name>>%LOGFILE% 2>&1
set LOGDIR1=logs\%BASEDIR%_%board%_%btype%
set LOGDIR=%CD%\logs\%BASEDIR%
set LOGDIR=%LOGDIR%_%board%_%btype%
set LOGDIR=%LOGDIR%

echo  - query internal_storage and external_storage>>%LOGFILE% 2>&1
echo  - set log path %LOGDIR% ok
md "%LOGDIR%">>%LOGFILE% 2>&1
echo  - get ro.build.fingerprint>>%LOGFILE% 2>&1
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.fingerprint]" > "%LOGDIR%\ro.build.fingerprint.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[dev.bootcomplete]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[init.svc.fuse_tempsd]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[init.svc.sdcard]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[init.svc.watchdogd]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.board.platform]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.date]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.host]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.user]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.version.sdk]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.hardware]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.product.hardware]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.product.model]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.product.name]" >> "%LOGDIR%\deviceinfo.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.runtime.firstboot]" >> "%LOGDIR%\deviceinfo.txt"
echo %VERSION% > "%LOGDIR%\toolsversion.txt"

echo %LOGDIR%>%latest_log_path%

echo  - create dirs
echo  - create dirs>>%LOGFILE% 2>&1
md "%LOGDIR%/internal_storage"
md "%LOGDIR%/external_storage"
md "%LOGDIR%/dropbox"
md "%LOGDIR%/hprofs"
md "%LOGDIR%/mms"
md "%LOGDIR%/media"
md "%LOGDIR%/contact"
md "%LOGDIR%/corefile"
md "%LOGDIR%/audio"
md "%LOGDIR%/sysdump"
md "%LOGDIR%/bt_reg"
md "%LOGDIR%/wifi_reg"
md "%LOGDIR%/cg"
md "%LOGDIR%/ffosdatabase"
rem add app logs
md "%LOGDIR%/app"

%ADB_CMD% shell slogctl query | %FIND_CMD% "internal" > "%cd%\tmp\internal_storage.txt"
%ADB_CMD% shell slogctl query | %FIND_CMD% "external" > "%cd%\tmp\external_storage.txt"
echo  - query internal_storage and external_storage ok

for /f "tokens=1,2 usebackq delims=," %%i in ("%cd%\tmp\internal_storage.txt") do set internal_storage=%%j
rem echo %internal_storage%

for /f "tokens=1,2 usebackq delims=," %%i in ("%cd%\tmp\external_storage.txt") do set external_storage=%%j
rem echo %external_storage%

echo  - get external path>>%LOGFILE% 2>&1
set external_path=%external_storage:slog=%/
echo  - external path is %external_path%>>%LOGFILE% 2>&1
echo  - external path is %external_path%

echo  - get current screen snap
echo  - get current screen snap>>%LOGFILE% 2>&1
%ADB_CMD% shell slogctl screen
%ADB_CMD% shell slogctl snap

echo  - get dropbox hprofs corefile
echo  - get dropbox hprofs corefile>>%LOGFILE% 2>&1
%ADB_CMD% pull /data/system/dropbox %LOGDIR%\dropbox>>%LOGFILE% 2>&1
%ADB_CMD% pull /data/misc/hprofs %LOGDIR%\hprofs>>%LOGFILE% 2>&1
%ADB_CMD% pull /data/corefile %LOGDIR%\corefile>>%LOGFILE% 2>&1
%ADB_CMD% pull /data/data/com.android.providers.telephony/databases/ %LOGDIR%/mms>>%LOGFILE% 2>&1
%ADB_CMD% pull /data/data/com.android.providers.media/databases/  %LOGDIR%/media>>%LOGFILE% 2>&1
%ADB_CMD% pull /data/data/com.android.providers.contacts/databases/  %LOGDIR%/contact>>%LOGFILE% 2>&1
echo  - get ffos mms sms contact call_log database
%ADB_CMD% pull /data/local/storage/persistent/chrome/idb  %LOGDIR%/ffosdatabase>>%LOGFILE% 2>&1

echo " - get app data">>%LOGFILE% 2>&1
if {%backup1%}=={1} (
md "%LOGDIR%/app/backup"
%ADB_CMD% pull  %external_path%/backup   %LOGDIR%/app/backup>>%LOGFILE% 2>&1
)
if {%dotbackup%}=={1} (
md "%LOGDIR%/app/dotbackup"
%ADB_CMD% pull  %external_path%/.backup   %LOGDIR%/app/dotbackup>>%LOGFILE% 2>&1
)
if {%profile%}=={1} (
md "%LOGDIR%/app/profile"
%ADB_CMD% pull  /data/data/com.sprd.audioprofile/   %LOGDIR%/app/profile>>%LOGFILE% 2>&1
)
if {%blacklist%}=={1} (
md "%LOGDIR%/app/blacklist"
%ADB_CMD% pull  /data/data/com.sprd.firewall/   %LOGDIR%/app/blacklist>>%LOGFILE% 2>&1
)
if {%bt_prefs%}=={1} (
md "%LOGDIR%/app/bt-prefs"
%ADB_CMD% pull  /data/data/com.android.settings/shared_prefs  %LOGDIR%/app/bt-prefs>>%LOGFILE% 2>&1
)
if {%bt_bluetooth%}=={1} (
md "%LOGDIR%/app/bt-bluetooth"
%ADB_CMD% pull  /data/data/com.android.bluetooth  %LOGDIR%/app/bt-bluetooth>>%LOGFILE% 2>&1
)
if {%bt_misc%}=={1} (
md "%LOGDIR%/app/app/bt-misc"
%ADB_CMD% pull  /data/misc/bluetooth/  %LOGDIR%/app/bt-misc>>%LOGFILE% 2>&1
)
if {%bt_miscd%}=={1} (
md "%LOGDIR%/app/bt-miscd"
%ADB_CMD% pull  /data/misc/bluetoothd/  %LOGDIR%/app/bt-miscd>>%LOGFILE% 2>&1
)
if {%contacts%}=={1} (
md "%LOGDIR%/app/contacts"
%ADB_CMD% pull   /data/data/com.android.providers.contacts  %LOGDIR%/app/contacts>>%LOGFILE% 2>&1
)
if {%dm%}=={1} (
md "%LOGDIR%/app/dm"
%ADB_CMD% pull   /data/data/com.android.providers.telephony/databases/telephony.db  %LOGDIR%/app/dm>>%LOGFILE% 2>&1
)
if {%fileexplorer%}=={1} (
md "%LOGDIR%/app/fileexplorer"
%ADB_CMD% pull   /data/data/com.android.providers.media/databases/  %LOGDIR%/app/fileexplorer>>%LOGFILE% 2>&1
)
if {%homescreen_launcher2%}=={1} (
md "%LOGDIR%/app/homescreen-launcher2"
%ADB_CMD% pull   /data/data/com.android.launcher2/  %LOGDIR%/app/homescreen-launcher2>>%LOGFILE% 2>&1
)
if {%homescreen_launcher3%}=={1} (
md "%LOGDIR%/app/homescreen-launcher3"
%ADB_CMD% pull   /data/data/com.android.launcher3/  %LOGDIR%/app/homescreen-launcher3>>%LOGFILE% 2>&1
)
if {%homescreen_sprd_launcher2%}=={1} (
md "%LOGDIR%/app/homescreen-sprd-launcher2"
%ADB_CMD% pull   /data/data/com.android.launcher2/  %LOGDIR%/app/homescreen-sprd-launcher2>>%LOGFILE% 2>&1
)
if {%homescreen_sprd_launcher3%}=={1} (
md "%LOGDIR%/app/homescreen-sprd-launcher3"
%ADB_CMD% pull   /data/data/com.android.sprdlauncher3/  %LOGDIR%/app/homescreen-sprd-launcher3>>%LOGFILE% 2>&1
)
if {%packageinstall%}=={1} (
md "%LOGDIR%/app/packageinstall"
%ADB_CMD% pull   /data/system/packages.xml  %LOGDIR%/app/packageinstall>>%LOGFILE% 2>&1
)
if {%phone_telephony%}=={1} (
md "%LOGDIR%/app/phone-telephony"
%ADB_CMD% pull   /data/data/com.android.providers.telephony  %LOGDIR%/app/phone-telephony>>%LOGFILE% 2>&1
)
if {%phone_contacts%}=={1} (
md "%LOGDIR%/app/phone-contacts"
%ADB_CMD% pull   /data/data/com.android.providers.contacts  %LOGDIR%/app/phone-contacts>>%LOGFILE% 2>&1
)
if {%settings%}=={1} (
md "%LOGDIR%/app/settings"
%ADB_CMD% pull   /data/data/com.android.providers.settings/ %LOGDIR%/app/settings>>%LOGFILE% 2>&1
)
if {%wifi%}=={1} (
md "%LOGDIR%/app/wifi"
%ADB_CMD% pull   /data/misc/wifi/  %LOGDIR%/app/wifi>>%LOGFILE% 2>&1
)

echo  - get modem_memory log...
echo  - get modem_memory log...>>%LOGFILE% 2>&1
%ADB_CMD% pull /sdcard/modem_memory.log %LOGDIR%/internal_storage/>>%LOGFILE% 2>&1
%ADB_CMD% pull /sdcard/external/modem_memory.log %LOGDIR%/external_storage/>>%LOGFILE% 2>&1

echo  - get log files
echo  - get log files>>%LOGFILE% 2>&1
%ADB_CMD% pull %internal_storage% %LOGDIR1%\internal_storage>>%LOGFILE% 2>&1
%ADB_CMD% pull %external_storage% %LOGDIR1%\external_storage>>%LOGFILE% 2>&1

echo  - get audio log files
echo  - get audio log files>>%LOGFILE% 2>&1
for /L %%i in (1,1,10) do %ADB_CMD% pull /proc/asound/sprdphone/vbc %LOGDIR%/audio/vbc-%%i>>%LOGFILE% 2>&1
%ADB_CMD% pull /proc/asound/sprdphone/sprd-codec %LOGDIR%/audio>>%LOGFILE% 2>&1
%ADB_CMD% pull /proc/asound/sprdphone/pcm0p/sub0/status %LOGDIR%/audio>>%LOGFILE% 2>&1
%ADB_CMD% shell tinymix > %LOGDIR%/audio/tinymix.log

rem echo - clear slog files
rem echo - clear slog files>>%LOGFILE% 2>&1
rem dir /a/b "%LOGDIR%/internal_storage" | findstr . > NUL&&%ADB_CMD% shell slogctl clear>>%LOGFILE% 2>&1

echo  - get kernel panic core file
echo  - get kernel panic core file>>%LOGFILE% 2>&1
rem %ADB_CMD% shell rm -r %external_path%sysdump/*>>%LOGFILE% 2>&1
%ADB_CMD% shell mkdir %external_path%sysdump/>>%LOGFILE% 2>&1
%ADB_CMD% shell mv %external_path%sysdump.core*  %external_path%sysdump/>>%LOGFILE% 2>&1
%ADB_CMD% pull %external_path%sysdump %LOGDIR%\sysdump>>%LOGFILE% 2>&1

echo  - get Trout BT log...
echo  - get Trout BT log...>>%LOGFILE% 2>&1
%ADB_CMD% shell "echo 1 > /sys/kernel/trout_debug/trout_btdebug_cmd">>%LOGFILE% 2>&1
%ADB_CMD% pull /data/bt_regsdata.txt %LOGDIR%\bt_reg>>%LOGFILE% 2>&1

echo  - get Trout WiFi log...
echo  - get Trout WiFi log...>>%LOGFILE% 2>&1
%ADB_CMD% shell "iwconfig wlan0 trout_dbg 2">>%LOGFILE% 2>&1
%ADB_CMD% shell "iwconfig wlan0 trout_dbg 8">>%LOGFILE% 2>&1
%ADB_CMD% pull /data/allregs.txt %LOGDIR%/wifi_reg/>>%LOGFILE% 2>&1

rem adapter iwconfig and trw command
echo  - check iwconfig execute ok or N>>%LOGFILE% 2>&1
if not exist %LOGDIR%/wifi_reg/allregs.txt (
%ADB_CMD% shell "trw get legacy 2">>%LOGFILE% 2>&1
%ADB_CMD% shell "trw get legacy 8">>%LOGFILE% 2>&1
%ADB_CMD% pull /data/allregs.txt %LOGDIR%/wifi_reg/>>%LOGFILE% 2>&1
)

echo  - get NMEA about log
echo  - get NMEA about log>>%LOGFILE% 2>&1
%ADB_CMD% pull /data/cg/online %LOGDIR%\cg>>%LOGFILE% 2>&1

rem echo  - clear sysdump files
rem dir /a/b "%LOGDIR%/sysdump" | findstr . > NUL&&%ADB_CMD% shell rm -r %external_path%sysdump/*>>%LOGFILE% 2>&1

rem for support 8825 4.1 4 cores
rem echo  - clear corefile files
rem dir /a/b "%LOGDIR%/corefile" | findstr . > NUL&&%ADB_CMD% shell rm -r /data/corefile/*>>%LOGFILE% 2>&1

rem for ffos
echo  - get ffos info
md "%LOGDIR%/ffos">>%LOGFILE% 2>&1
%ADB_CMD% pull /data/b2g/mozilla/ %LOGDIR%\ffos>>%LOGFILE% 2>&1

echo  - get bt logs for-android  4.1_3.4
echo  - get bt logs for-android  4.1_3.4>>%LOGFILE% 2>&1
md "%LOGDIR%/bt">>%LOGFILE% 2>&1
%ADB_CMD% pull /sdcard/btsnoop_hci.log %LOGDIR%/bt/>>%LOGFILE% 2>&1
echo  - capture log finished at  %date% %time%>>%LOGFILE% 2>&1
cd %base_dir%\
echo   " check logs"
python logCheck.py %LOGDIR% >>%LOGFILE% 2>&1
python genDir.py  %LOGDIR% >>%LOGFILE% 2>&1
