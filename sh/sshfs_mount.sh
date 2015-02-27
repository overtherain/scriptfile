#!/bin/bash
#read -p "Connect shareusr to local:" ch
IP=`ifconfig eth0  | grep -i 'inet ad' | awk '{print $2}' | cut -d':' -f2`
echo IP:${IP}
case $IP in
	${BUILD_SERVER})
		echo sshfs ${ZTKJ_LOCAL_USER}@${ZTKJ_LOCAL}:/home/${ZTKJ_LOCAL_USER}/develop ${MNT_ROOT}/develop
		sshfs ${BUILD_SERVER_USER5}@${ZTKJ_LOCAL}:/home/${ZTKJ_LOCAL_USER}/develop ${MNT_ROOT}/develop
		echo sshfs ${ZTKJ_LOCAL_USER}@${ZTKJ_LOCAL}:/home/${ZTKJ_LOCAL_USER} ${MNT_ROOT}/home
		sshfs ${ZTKJ_LOCAL_USER}@${ZTKJ_LOCAL}:/home/${ZTKJ_LOCAL_USER} ${MNT_ROOT}/home
		exit 0;
		;;
	${AUTOTEST_SERVER})
		echo sshfs ${AUTOTEST_SERVER_USER}@${AUTOTEST_SERVER}:/ ${MNT}/autotest
		sshfs ${AUTOTEST_SERVER_USER}@${AUTOTEST_SERVER}:/ ${MNT}/autotest
		exit 0;
		;;
	${WEB_SERVER})
		echo sshfs ${WEB_SERVER_USER}@${WEB_SERVER}:/ ${MNT_ROOT}/webserver
		sshfs ${WEB_SERVER_USER}@${WEB_SERVER}:/ ${MNT_ROOT}/webserver
		exit 0;
		;;
esac
ch=$1
echo USER:$ch
case $ch in
	y|Y|yes|Yes|YES)
		echo "Mount share to local:"
		echo sshfs ${BUILD_SERVER_USER0}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER0} ${MNT_ROOT}/${BUILD_SERVER_USER0}
		sshfs ${BUILD_SERVER_USER0}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER0} ${MNT_ROOT}/${BUILD_SERVER_USER0}
		;;
	${BUILD_SERVER_USER1})
		echo "Mount yjx to local:"
		echo sshfs ${BUILD_SERVER_USER1}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER1} ${MNT_ROOT}/${BUILD_SERVER_USER1}
		sshfs ${BUILD_SERVER_USER1}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER1} ${MNT_ROOT}/${BUILD_SERVER_USER1}
		;;
	${BUILD_SERVER_USER2})
		echo "Mount xyq to local:"
		echo sshfs ${BUILD_SERVER_USER2}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER2} ${MNT_ROOT}/${BUILD_SERVER_USER2}
		sshfs ${BUILD_SERVER_USER2}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER2} ${MNT_ROOT}/${BUILD_SERVER_USER2}
		;;
	${BUILD_SERVER_USER3})
		echo "Mount yjx to local:"
		echo sshfs ${BUILD_SERVER_USER3}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER3} ${MNT_ROOT}/${BUILD_SERVER_USER3}
		sshfs ${BUILD_SERVER_USER3}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER3} ${MNT_ROOT}/${BUILD_SERVER_USER3}
		;;
	${ZTKJ_SERVER_USER})
		echo "Mount ztkj.cn to local:"
		echo sshfs ${ZTKJ_SERVER_USER}@${ZTKJ_SERVER}:/home/${ZTKJ_SERVER_USER} ${MNT_ROOT}/${ZTKJ_SERVER_USER}
		sshfs ${ZTKJ_SERVER_USER}@${ZTKJ_SERVER}:/home/${ZTKJ_SERVER_USER} ${MNT_ROOT}/${ZTKJ_SERVER_USER}
		;;
	${ZTKJ_LOCAL_USER})
		echo "Mount ${ZTKJ_LOCAL} to `ifconfig`"
		;;
	*)
		echo "Mount self to local:"
		echo sshfs ${BUILD_SERVER_USER}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER} ${MNT_ROOT}/server
		sshfs ${BUILD_SERVER_USER}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER} ${MNT_ROOT}/server
		;;
esac

