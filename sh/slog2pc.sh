#!/bin/bash
TOPDIR=`pwd`
echo `whoami`: slog_dir="${MSHELL}/sh/slog.tools"
slog_dir="${MSHELL}/sh/slog.tools"
echo `whoami`: cd ${slog_dir}
cd ${slog_dir}

echo `whoami`: /bin/bash LogAndroid2PC.sh ${TOPDIR}
/bin/bash LogAndroid2PC.sh ${TOPDIR}
