#!/bin/bash
read -p "input your password:" password
sudo mount -t cifs -o		\
			username=${ZTKJ_SERVER_USER},password=${password},uid=${ZTKJ_SERVER_USER},gid=${ZTKJ_SERVER_USER}	\
			${ZTKJ_SERVER_URL}	${ZTKJ_SERVER_POINT}
name=******
password=******
echo sudo mount -t cifs -o \
			username=${name},password=${password},uid=${name},gid=${name} \
			${ZTKJ_SERVER_URL}	${ZTKJ_SERVER_POINT}
