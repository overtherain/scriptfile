::V1.6.0
@echo off
echo - set env
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
echo         path:%path%
echo         classpath:%classpath%
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

rem set log dir name
set LOGDIR=androidlog_%DATE:~0,10%%TIME:~0,8%
if {%XT%}=={windows7} (set LOGDIR=%LOGDIR:/=%) else (set LOGDIR=%LOGDIR:-=%)
set LOGDIR=%LOGDIR::=%
set LOGDIR=%LOGDIR: =%
set LOGDIR=%CD%\logs\%LOGDIR%
set LOGDIR=%LOGDIR%_%board%_%btype%
echo %LOGDIR% > %cd%\tmp\~testing
set LOGDIR="%LOGDIR%"
mkdir %LOGDIR% 1>NUL 2>NUL

@echo off
rem echo ........
rem echo %board%
rem echo %btype%
rem echo %XT%
rem echo ........

if {%btype%}=={eng} (
 goto eng
) else if {%btype%}=={user} (
goto eng
) else if {%btype%}=={userdebug} (
goto eng
)

:eng
rem we don't need logs4andriod running on the DUT
rem %ADB_CMD% shell stop logs4android

Rem backup the old logs before capture log
set LOGDIR_OLD=%LOGDIR%\old_log
mkdir %LOGDIR_OLD%
mkdir %LOGDIR_OLD%\apanic
mkdir %LOGDIR_OLD%\anr
mkdir %LOGDIR_OLD%\hprofs
mkdir %LOGDIR_OLD%\com.android.providers.telephony
mkdir %LOGDIR_OLD%\logs4android
mkdir %LOGDIR_OLD%\logs4modem
mkdir %LOGDIR_OLD%\bt
mkdir %LOGDIR_OLD%\gps

echo  - get DUT information
%ADB_CMD% shell getprop > %LOGDIR_OLD%\deviceinfo.txt
%ADB_CMD% shell df > %LOGDIR_OLD%\diskUsageInfo.txt
if {%btype%} == {user} (
echo  - skip recorder memoinfo --user
) else (
%ADB_CMD% shell free > %LOGDIR_OLD%\memoryUsageInfo.txt
)
%ADB_CMD% shell top -n 1 > %LOGDIR_OLD%\processInfo.txt

Rem capture old log
echo  - app_parts/mmssms.db...
%ADB_CMD% pull /data/data/com.android.providers.telephony/app_parts %LOGDIR_OLD%/com.android.providers.telephony 1>NUL 2>NUL
%ADB_CMD% pull /data/data/com.android.providers.telephony/databases/mmssms.db %LOGDIR_OLD%/com.android.providers.telephony 1>NUL 2>NUL

echo  - logs4android...
%ADB_CMD% pull /sdcard/logs4android/ %LOGDIR_OLD%/logs4android 1>NUL 2>NUL

echo  - logs4modem...
%ADB_CMD% pull /sdcard/logs4modem/ %LOGDIR_OLD%/logs4modem 1>NUL 2>NUL

echo  - anr trace...
%ADB_CMD% pull /data/anr/ %LOGDIR_OLD%\anr 1>NUL 2>NUL

echo  - tombstones...
%ADB_CMD% pull /data/tombstones %LOGDIR_OLD%/tombstones 1>NUL 2>NUL

echo  - snapshot...
if {%btype%}=={user} (
%JAVA_CMD% -jar %cd%\tools\Screenshot.jar %LOGDIR_OLD%\snapshot.png 1>NUL 2>NUL
) else (
%ADB_CMD% shell gsnap snapshot.png /dev/graphics/fb0 1>NUL 2>NUL
%ADB_CMD% pull /snapshot.png %LOGDIR_OLD% 1>NUL 2>NUL
)

echo  - apanic...
%ADB_CMD% pull /data/dontpanic/apanic_console %LOGDIR_OLD%\apanic 1>NUL 2>NUL
%ADB_CMD% pull /data/dontpanic/apanic_threads %LOGDIR_OLD%\apanic 1>NUL 2>NUL

echo  - hprofs/*...
%ADB_CMD% pull /data/misc/hprofs/* %LOGDIR_OLD%/hprofs/ 1>NUL 2>NUL

if {%androidVer%}=={2.3.5} (
	%ADB_CMD% pull /data/sirf_interface_log.txt %LOGDIR_OLD%\gps
	%ADB_CMD% pull /data/DetailedLog.txt %LOGDIR_OLD%\gps
	%ADB_CMD% pull /data/BriefLog.txt %LOGDIR_OLD%\gps
	%ADB_CMD% pull /data/A-GPS.LOG %LOGDIR_OLD%\gps
	%ADB_CMD% pull /data/nav.gps %LOGDIR_OLD%\gps
	goto :getNVMLog1
) else (
	goto :bt
)

set /a counter=0
:getNVMLog1
%ADB_CMD% pull /data/NVM%counter% %LOGDIR_OLD%\gps
echo pull NVM %counter%
set /a counter=%counter%+1
if %counter% lss 50 goto :getNVMLog1

:bt
echo  - bt log
%ADB_CMD% pull /data/hcidump_bt.cfa %LOGDIR_OLD%\bt

if {%btype%}=={user} (
	echo  - skip deleting old log files
	goto :next
) else (
	echo  - deleting old log files...
	%ADB_CMD% shell rm -rf /data/tombstones 1>NUL 2>NUL
	%ADB_CMD% shell rm -rf /data/dontpanic/ 1>NUL 2>NUL
	%ADB_CMD% shell rm -rf /data/anr/ 1>NUL 2>NUL
	%ADB_CMD% shell rm -rf /data/misc/hprofs/ 1>NUL 2>NUL
	%ADB_CMD% shell rm -rf /data/hcidump_bt.cfa 1>NUL 2>NUL
)

:next
rem start logging various android log
%ADB_CMD% shell setprop log.tag.Mms:transaction VERBOSE
start /b %ADB_CMD% logcat -v threadtime >%LOGDIR%/logcat_main.log
start /b %ADB_CMD% logcat -b radio -v threadtime  >%LOGDIR%/logcat_radio.log
if {%btype%}=={user} (
	echo  - skip capture kmsg tcpdump and hcidump logs
) else (
	start /b %ADB_CMD% shell cat /proc/kmsg  >%LOGDIR%/kmsg.log
	start /b %ADB_CMD% shell tcpdump -i any -p -s 0 -w /sdcard/capture.pcap
	rem new add wifi log
	if {%androidVer%}=={4.0.3} (
		rem start /b %ADB_CMD% shell hcidump -Xt >%LOGDIR%/hcidump.log
		start /b %ADB_CMD% shell hcidump -w /data/hcidump_bt.cfa
	) else (
		rem start /b %ADB_CMD% shell hcidump -XVt >%LOGDIR%/hcidump.log
		start /b %ADB_CMD% shell hcidump --btsnoop -w /data/hcidump_bt.cfa
	)
)
goto end

:exception
echo press any key to exit!
pause
exit

:end
echo ********************************************************
echo Start logging the Android device into:
echo   %LOGDIR%
echo.
echo *********************************************
echo    PC system is : %XT%
echo    DUT android version is : %androidVer%
echo    DUT product.board is : %board%
echo    DUT build.type is : %btype%
echo *********************************************
echo  Process running on background!!!
echo  This process will be killed after running StopLogging.bat
echo     !!! Don't close this window mannually !!!
echo.
echo ********************************************************
goto :EOF
