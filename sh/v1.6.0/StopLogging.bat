::V1.6.0
@echo off
echo  - set env
set ADB_CMD=%cd%\tools\adb.exe
set PING_CMD=%cd%\tools\ping.exe
set JAVA_CMD=%cd%\tools\jre\bin\java.exe
set FIND_CMD=%cd%\tools\find.exe
set path=%cd%\tools\jre\bin;%cd%\tools;%path%
set classpath=%cd%\tools\jre\lib

rem check env exist
if exist %ADB_CMD% ( echo  - adb ok ) else (
echo adb command can not be found,please re unzip the tools!exit
goto exception
)
if exist %PING_CMD% ( echo  - ping ok ) else (
echo ping command can not be found,please re unzip the tools!exit
goto exception
)
if exist %JAVA_CMD% ( echo  - java ok ) else (
echo java command can not be found,please re unzip the tools!exit
goto exception
)
if exist %FIND_CMD% ( echo  - find ok ) else (
echo find command can not be found,please re unzip the tools!exit
goto exception
)

echo ....................use env.....................
echo         adb:%ADB_CMD%
echo        java:%JAVA_CMD%
echo        path:%path%
echo   classpath:%classpath%
echo ....................use env.....................

java -version
echo  - checking connection...
rem %ADB_CMD% kill-server
%ADB_CMD% root
%ADB_CMD% wait-for-device
%ADB_CMD% devices
echo  - device connected.

rem win7 date behaves differently..
rem echo get pc system version
ver | find "5.1" > NUL && set XT=windowsXP
ver | find "6.1" > NUL && set XT=windows7

adb shell getprop | find "[ro.build.type]" > %cd%\tmp\ro.build.type.txt
adb shell getprop | find "[ro.product.board]" > %cd%\tmp\ro.product.board.txt
adb shell getprop | find "[ro.build.version.release]" > %cd%\tmp\ro.build.version.release.txt

Rem wait for 3 seconds
@%PING_CMD% 127.0.0.1 -n 2 > NUL

echo  - get ro.build.type
for /f "tokens=1,* usebackq delims= " %%i in (%cd%\tmp\ro.build.type.txt) do set btype=%%j
set btype=%btype:~1,-2%
rem echo %btype%

echo  - get ro.product.board
for /f "tokens=1,* usebackq delims= " %%i in (%cd%\tmp\ro.product.board.txt) do set board=%%j
set board=%board:~1,-2%
rem echo %board%

echo  - get ro.build.version.release
for /f "tokens=1,* usebackq delims= " %%i in (%cd%\tmp\ro.build.version.release.txt) do set androidVer=%%j
set androidVer=%androidVer:~1,-2%
rem echo %androidVer%

if exist %cd%\tmp\~testing goto _inLogging

rem set log dir name
set LOGDIR=androidlog_%DATE:~0,10%%TIME:~0,8%
if {%XT%}=={windows7} (set LOGDIR=%LOGDIR:/=%) else (set LOGDIR=%LOGDIR:-=%)
set LOGDIR=%LOGDIR::=%
set LOGDIR=%LOGDIR: =%
set LOGDIR=%CD%\logs\%LOGDIR%
set LOGDIR=%LOGDIR%_%board%_%btype%
set LOGDIR="%LOGDIR%"
mkdir %LOGDIR% 1>NUL 2>NUL
goto getLog

:_inLogging
for /f "usebackq delims=" %%i in (%cd%\tmp\~testing) do set LOGDIR=%%i
if "%LOGDIR:~-1%"==" " set "LOGDIR=%LOGDIR:~0,-1%"
set LOGDIR="%LOGDIR%"
del %cd%\tmp\~testing
goto getLog

:getLog
if {%btype%}=={eng} (
 goto _getLog
) else if {%btype%}=={user} (
goto _getLog
) else if {%btype%}=={userdebug} (
goto _getLog
)

:_getLog
mkdir %LOGDIR% 1>NUL 2>NUL

rem test whether android device is still accessible
%ADB_CMD% devices >NUL
%ADB_CMD% get-state > %cd%\tmp\~state
for /f %%i in (%cd%\tmp\~state) do set ADEVICE=%%i
del %cd%\tmp\~state
if %ADEVICE%==unknown goto _need2Restart

echo ********************************************************
echo Collecting Android log/infomation from device to:
echo   %LOGDIR%
echo.

rem stop logging, so we have less 'extra' stuff recorded
rem %ADB_CMD% kill-server 1>NUL 2>NUL
%ADB_CMD% root 1>NUL 2>NUL

rem start to save log files
%ADB_CMD% wait-for-device

echo  - get DUT information
%ADB_CMD% shell getprop > %LOGDIR%\deviceinfo.txt
%ADB_CMD% shell df > %LOGDIR%\diskUsageInfo.txt
if {%btype%} == {user} (
echo  - skip recorder memoinfo --user
) else (
%ADB_CMD% shell free > %LOGDIR%\memoryUsageInfo.txt
)
%ADB_CMD% shell top -n 1 > %LOGDIR%\processInfo.txt

echo  - app_parts/mmssms.db...
mkdir %LOGDIR%\com.android.providers.telephony 1>NUL 2>NUL
%ADB_CMD% pull /data/data/com.android.providers.telephony/app_parts %LOGDIR%/com.android.providers.telephony 1>NUL 2>NUL
%ADB_CMD% pull /data/data/com.android.providers.telephony/databases/mmssms.db %LOGDIR%/com.android.providers.telephony 1>NUL 2>NUL

echo  - logs4android...
mkdir %LOGDIR%\logs4android 1>NUL 2>NUL
%ADB_CMD% pull /sdcard/logs4android/ %LOGDIR%/logs4android 1>NUL 2>NUL

echo  - logs4modem...
mkdir %LOGDIR%\logs4modem 1>NUL 2>NUL
%ADB_CMD% pull /sdcard/logs4modem/ %LOGDIR%/logs4modem 1>NUL 2>NUL

echo  - anr trace...
mkdir %LOGDIR%\anr 1>NUL 2>NUL
%ADB_CMD% pull /data/anr/ %LOGDIR%\anr 1>NUL 2>NUL

rem echo  - tombstones...
rem mkdir %LOGDIR%\tombstones 1>NUL 2>NUL
rem %ADB_CMD% pull /data/tombstones %LOGDIR%/tombstones 1>NUL 2>NUL

echo  - capture.pcap...
%ADB_CMD% pull /sdcard/capture.pcap %LOGDIR% 1>NUL 2>NUL

echo  - snapshot...
if {%btype%}=={user} (
%JAVA_CMD% -jar %cd%\tools\Screenshot.jar %LOGDIR%\snapshot.png 1>NUL 2>NUL
) else (
%ADB_CMD% shell gsnap snapshot.png /dev/graphics/fb0 1>NUL 2>NUL
%ADB_CMD% pull /snapshot.png %LOGDIR% 1>NUL 2>NUL
)

echo  - apanic...
mkdir %LOGDIR%\apanic 1>NUL 2>NUL
%ADB_CMD% pull /data/dontpanic/apanic_console %LOGDIR%\apanic 1>NUL 2>NUL
%ADB_CMD% pull /data/dontpanic/apanic_threads %LOGDIR%\apanic 1>NUL 2>NUL

echo  - last_kmsg...
%ADB_CMD% pull /proc/last_kmsg %LOGDIR% 1>NUL 2>NUL

echo  - hprofs/*...
mkdir %LOGDIR%/hprofs 1>NUL 2>NUL
%ADB_CMD% pull /data/misc/hprofs %LOGDIR%/hprofs 1>NUL 2>NUL
if {%btype%}=={user} (
echo  - skip del /data/misc/hprofs/ --user
) else (
%ADB_CMD% shell rm -r /data/misc/hprofs/ 1>NUL 2>NUL
)

echo  - bugreport...
%ADB_CMD% bugreport  >%LOGDIR%/bugreport.log

echo  - gps log -- only for 8810ga
mkdir %LOGDIR%\gps
if {%androidVer%}=={2.3.5} (
%ADB_CMD% pull /data/sirf_interface_log.txt %LOGDIR%\gps
%ADB_CMD% pull /data/DetailedLog.txt %LOGDIR%\gps
%ADB_CMD% pull /data/BriefLog.txt %LOGDIR%\gps
%ADB_CMD% pull /data/A-GPS.LOG %LOGDIR%\gps
%ADB_CMD% pull /data/nav.gps %LOGDIR%\gps
goto :getNVMLog2
) else (
goto :next
)

set /a counter2=0
:getNVMLog2
%ADB_CMD% pull /data/NVM%counter2% %LOGDIR%\gps
echo pull NVM %counter2%
set /a counter2=%counter2%+1
if %counter2% lss 50 goto :getNVMLog2

:next
echo  - bt log
mkdir %LOGDIR%\bt
%ADB_CMD% pull /data/hcidump_bt.cfa %LOGDIR%\bt

echo .
echo DONE!
echo ********************************************************
%ADB_CMD% kill-server 1>NUL 2>NUL
goto end

:_need2Restart
%ADB_CMD% kill-server
date /T >>%LOGDIR%/Fail2AccessThruADB
time /T >>%LOGDIR%/Fail2AccessThruADB
echo %LOGDIR% > %cd%\tmp\~testing

echo ********************************************************
echo         !!! DUT is not accessible thru ADB !!!
echo   please:
echo     1. check whether arm/dsp log is still "alive", or, 
echo        even better, call the DUT to check its reaction
echo     2. restart the device and run the batch again
echo ********************************************************
goto end

:end
pause