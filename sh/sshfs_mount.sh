#!/bin/bash
#read -p "Connect shareusr to local:" ch
ch=$1
case $ch in
	y|Y|yes|Yes|YES)
		echo "Mount share to local:"
		sshfs ${BUILD_SERVER_USER0}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER0} ${MNT_ROOT}/${BUILD_SERVER_USER0}
		;;
	${BUILD_SERVER_USER1})
		echo "Mount yjx to local:"
		sshfs ${BUILD_SERVER_USER1}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER1} ${MNT_ROOT}/${BUILD_SERVER_USER1}
		;;
	${BUILD_SERVER_USER2})
		echo "Mount xyq to local:"
		sshfs ${BUILD_SERVER_USER2}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER2} ${MNT_ROOT}/${BUILD_SERVER_USER2}
		;;
	*)
		echo "Mount self to local:"
		sshfs ${BUILD_SERVER_USER}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER} ${MNT_ROOT}/server
		;;
esac

