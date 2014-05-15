#!/bin/bash
# init var
total=$1;
i=0;
ct=$i+1000;
cTime="_`date +%Y.%m.%d_%H.%M.%S`"
#echo ${REPORT_DIR}
cd ${REPORT_DIR}
#pwd

#========================================
# v0.0.1
#========================================
echo "area's url: "${AREA_URL}
echo "area's file: "${AREA_FILE}
curl -k ${AREA_URL} > ${AREA_FILE}
cat ${AREA_FILE}
echo ${TYPE_URL}
echo ${TYPE_FILE}
curl -k ${TYPE_URL} > ${TYPE_FILE}
cat ${TYPE_FILE}

#========================================
# v0.0.2
#========================================
#area=`wget --no-check-certificate "${AREA_FILE}"`
#echo $? $area
#echo "move '${TMP_AREA}' to '${AREA_FILE}'"
#mv "${TMP_AREA}" "${AREA_FILE}"
#sleep 1
#wget --no-check-certificate "${AREA_FILE}"
#echo $?
#echo "move '${TMP_TYPE}' to '${TYPE_FILE}'"
#mv "${TMP_TYPE}" "${TYPE_FILE}"

