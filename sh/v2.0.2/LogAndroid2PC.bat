::2.0.2
@echo off
echo - set env
set ADB_CMD="%cd%\tools\adb.exe"
set FIND_CMD="%cd%\tools\find.exe"

echo - check adb connection
rem %ADB_CMD% kill-server
%ADB_CMD% root
%ADB_CMD% wait-for-device
%ADB_CMD% devices
echo  - device connected.

rem win7 date behaves differently..
rem echo get pc system version
ver | find "5.1" > NUL && set XT=windowsXP
ver | find "6.1" > NUL && set XT=windows7


%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.type]" > "%cd%\tmp\ro.build.type.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.product.board]" > "%cd%\tmp\ro.product.board.txt"
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.version.release]" > "%cd%\tmp\ro.build.version.release.txt"


echo  - get ro.build.type
for /f "tokens=1,* usebackq delims= " %%i in ("%cd%\tmp\ro.build.type.txt") do set btype=%%j
set btype=%btype:~1,-2%
rem echo %btype%

echo  - get ro.product.board
for /f "tokens=1,* usebackq delims= " %%i in ("%cd%\tmp\ro.product.board.txt") do set board=%%j
set board=%board:~1,-2%
rem echo %board%

echo  - get ro.build.version.release
for /f "tokens=1,* usebackq delims= " %%i in ("%cd%\tmp\ro.build.version.release.txt") do set androidVer=%%j
set androidVer=%androidVer:~1,-2%
rem echo %androidVer%

echo  - set log dir name
set LOGDIR=slog_%DATE:~0,10%%TIME:~0,8%
if {%XT%}=={windows7} (set LOGDIR=%LOGDIR:/=%) else (set LOGDIR=%LOGDIR:-=%)
set LOGDIR=%LOGDIR::=%
set LOGDIR=%LOGDIR: =%
set LOGDIR1=logs\%LOGDIR%_%board%_%btype%
set LOGDIR=%CD%\logs\%LOGDIR%
set LOGDIR=%LOGDIR%_%board%_%btype%
set LOGDIR=%LOGDIR%
md "%LOGDIR%"
echo  - get ro.build.fingerprint 
%ADB_CMD% shell getprop | %FIND_CMD% "[ro.build.fingerprint]" > "%LOGDIR%\ro.build.fingerprint.txt"
echo 2.0.2 > "%LOGDIR%\toolsversion.txt"

echo  - create dirs
md "%LOGDIR%/internal_storage"
md "%LOGDIR%/external_storage"
md "%LOGDIR%/external_storage/dropbox"
md "%LOGDIR%/external_storage/hprofs"

echo  - query internal_storage and external_storage
%ADB_CMD% shell slogctl query | %FIND_CMD% "internal" > "%cd%\tmp\internal_storage.txt"
%ADB_CMD% shell slogctl query | %FIND_CMD% "external" > "%cd%\tmp\external_storage.txt"

for /f "tokens=1,2 usebackq delims=," %%i in ("%cd%\tmp\internal_storage.txt") do set internal_storage=%%j
rem echo %internal_storage%

for /f "tokens=1,2 usebackq delims=," %%i in ("%cd%\tmp\external_storage.txt") do set external_storage=%%j
rem echo %external_storage%

echo  - get current screen snap bugreport
%ADB_CMD% shell slogctl screen
%ADB_CMD% shell slogctl snap
%ADB_CMD% shell slogctl snap bugreport

echo  - get dropbox and hprofs
%ADB_CMD% pull /data/system/dropbox %LOGDIR%\external_storage\dropbox
%ADB_CMD% pull /data/misc/hprofs %LOGDIR%\external_storage\hprofs

echo  - get log files
%ADB_CMD% pull %internal_storage% %LOGDIR1%\internal_storage
%ADB_CMD% pull %external_storage% %LOGDIR1%\external_storage

echo - clear log files
%ADB_CMD% shell slogctl clear
