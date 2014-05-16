::2.2.4
@echo off
echo  - set env
set VERSION=2.2.4
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

echo  - version:%VERSION%>>%LOGFILE% 2>&1
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

echo  - set log path %LOGDIR% ok
md "%LOGDIR%">>%LOGFILE% 2>&1
echo  - get ro.build.fingerprint>>%LOGFILE% 2>&1
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.fingerprint]" > "%LOGDIR%\ro.build.fingerprint.txt"
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
md "%LOGDIR%/corefile"
md "%LOGDIR%/audio"
md "%LOGDIR%/sysdump"
md "%LOGDIR%/bt_reg"
md "%LOGDIR%/wifi_reg"
md "%LOGDIR%/cg"
md "%LOGDIR%/bugreport"

echo  - query internal_storage and external_storage>>%LOGFILE% 2>&1
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
%ADB_CMD% pull /data/data/com.android.providers.telephony/ %LOGDIR%/mms>>%LOGFILE% 2>&1
%ADB_CMD% pull /data/data/com.android.providers.media/databases/  %LOGDIR%/media>>%LOGFILE% 2>&1

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

echo - clear slog files
echo - clear slog files>>%LOGFILE% 2>&1
dir /a/b "%LOGDIR%/internal_storage" | findstr . > NUL&&%ADB_CMD% shell slogctl clear>>%LOGFILE% 2>&1

echo  - get kernel panic core file
echo  - get kernel panic core file>>%LOGFILE% 2>&1
%ADB_CMD% shell rm -r %external_path%sysdump/*>>%LOGFILE% 2>&1
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

echo  - clear sysdump files
dir /a/b "%LOGDIR%/sysdump" | findstr . > NUL&&%ADB_CMD% shell rm -r %external_path%sysdump/*>>%LOGFILE% 2>&1

rem for support 8825 4.1 4 cores
echo  - clear corefile files
dir /a/b "%LOGDIR%/corefile" | findstr . > NUL&&%ADB_CMD% shell rm -r /data/corefile/*>>%LOGFILE% 2>&1

rem for ffos
echo  - get ffos info
md "%LOGDIR%/ffos">>%LOGFILE% 2>&1
%ADB_CMD% pull /data/b2g/mozilla/ %LOGDIR%\ffos>>%LOGFILE% 2>&1

echo  - get bt logs for-android  4.1_3.4
echo  - get bt logs for-android  4.1_3.4>>%LOGFILE% 2>&1
md "%LOGDIR%/bt">>%LOGFILE% 2>&1
%ADB_CMD% pull /sdcard/btsnoop_hci.log %LOGDIR%/bt/>>%LOGFILE% 2>&1

echo  - getbugreport info>>%LOGFILE% 2>&1
echo  - getbugreport info
%ADB_CMD% shell bugreport > %LOGDIR%/bugreport/bugreport.log
