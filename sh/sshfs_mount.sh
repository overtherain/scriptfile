#!/bin/bash
#read -p "Connect shareusr to local:" ch
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
	${BUILD_SERVER_USER4})
		echo "Mount yjx to local:"
		echo sshfs ${BUILD_SERVER_USER4}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER4} ${MNT_ROOT}/${BUILD_SERVER_USER4}
		sshfs ${BUILD_SERVER_USER4}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER4} ${MNT_ROOT}/${BUILD_SERVER_USER4}
		;;
	*)
		echo "Mount self to local:"
		echo sshfs ${BUILD_SERVER_USER}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER} ${MNT_ROOT}/server
		sshfs ${BUILD_SERVER_USER}@${BUILD_SERVER}:/home/${BUILD_SERVER_USER} ${MNT_ROOT}/server
		;;
esac

