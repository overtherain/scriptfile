#! /bin/bash
#program directory path
PRO_PATH="${DALIY_REPORT_DIR}"
#program name
PRO_NAME="daliy.push.report"
#program path, not need configure.
PRO_MAIN=$PRO_PATH/$PRO_NAME
echo $PRO_MAIN
while true ; do
    PRO_NOW=`ps aux | grep $PRO_NAME | grep -v grep | wc -l`
    if [ $PRO_NOW -lt 1 ]; then
       cd $PRO_PATH
       daliy.push.report
       date >> $PRO_PATH/tinfo.log
       echo "------------------$PRO_MAIN start----------------------" >> $PRO_PATH/tinfo.log
    fi
    # do this every 12 hours
    sleep 43200
done
exit 0
