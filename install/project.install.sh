#!/bin/bash

## Sprd log-tools
ln -s ${MSHELL}/sh/v1.6.0/logs4android.sh ${MSHELL}/run/log4android
ln -s ${MSHELL}/sh/v2.1.9/LogAndroid2PC.sh ${MSHELL}/run/slog2pc
ln -s ${MSHELL}/sh/v2.0.2/LogAndroid2PC.sh ${MSHELL}/run/slog2pc.202
ln -s ${MSHELL}/sh/v2.0.6/LogAndroid2PC.sh ${MSHELL}/run/slog2pc.206
ln -s ${MSHELL}/sh/v2.0.2_ali/LogAndroid2PC.sh ${MSHELL}/run/slog2pc.ali

## Single log tools
ln -s ${MSHELL}/sh/logbugreport.sh ${MSHELL}/run/logbugreport
ln -s ${MSHELL}/sh/logcat_main.sh ${MSHELL}/run/logcat_main
ln -s ${MSHELL}/sh/kmsg.sh ${MSHELL}/run/logkmsg
ln -s ${MSHELL}/sh/chkbugreport-0.4-164/BugReport.sh ${MSHELL}/run/bugreport
ln -s ${MSHELL}/sh/tcpdump.sh ${MSHELL}/run/caplog

## get tcpdump(cap package)
ln -s ${MSHELL}/sh/getcap.sh ${MSHELL}/run/gettcp

ln -s ${MSHELL}/sh/usrlog.sh ${MSHELL}/run/usrlog

