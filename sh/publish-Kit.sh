#!/bin/bash
#####################################################################################
#
# Copyright (c) 2013 M.R.Z <zgd1348833@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#====================================================================================
#                       ATTENTION PLEASE
# -----------------------------------------------------------------------------------
# @2013.12.17
# @M.R.Z <zgd1348833@gmail.com>
# ___________________________________________________________________________________
#### USEAGE:
# use
#	ls -l publish-Kit.sh
# to check if have exec permission.
# if not, use
#	chmod +x publish-Kit.sh
# to exec this file.
#	./publish-Kit.sh
#
#####################################################################################
#### USER CONFIG: Modify this area for your settings
## global
# this is root fold
ROOT_DIR=${PWD}
# backup fold
BACKUP_DIR=${ROOT_DIR}/backup
# publish fold
PUBLISH_DIR=${ROOT_DIR}/publish
# apache, nginx used fold
USED_DIR="current"
# git tag, use this as version id
GIT_TAG=
# publish or debug
CONFIG_ST="debug"
# publish config file
PUBLISH_CFG=config.publish.ini
# debug config file
DEBUG_CFG=config.debug.ini
# using config
CONFIG_FILE=config.ini
# git url
GIT_URL=${ROOT_DIR}/src
# temp fold
TEMP_DIR=${ROOT_DIR}/temp
#
#####################################################################################
#### FUNCTION START: DO NOT modify this unless you really know all of this source file.
## check folder
mkdir -p ${BACKUP_DIR}
mkdir -p ${PUBLISH_DIR}
mkdir -p ${TEMP_DIR}

## get new git
git clone ${GIT_URL} ${TEMP_DIR}/code
ret=$?
case $ret in
        0)
                ;;
        *)
                echo -e "ERROR: $ret\n"
                ;;
esac
pwd
cd ${TEMP_DIR}/code
echo "Tags is belowing...:"
git tag
pwd
cd -
pwd
read -p "Choose tag: " GIT_TAG
echo "You have choose \"${GIT_TAG}\"."
read -p "Choose 'publish' or 'debug':" CONFIG_ST
echo "You have choose \"${CONFIG_ST}\"."
## backup
ls ${PUBLISH_DIR}
rm -vf ${PUBLISH_DIR}/${USED_DIR}
mv ${PUBLISH_DIR}/* ${BACKUP_DIR}/

## get code
mv ${TEMP_DIR}/code ${PUBLISH_DIR}/${GIT_TAG}
cd ${PUBLISH_DIR}/${GIT_TAG}
git checkout ${GIT_TAG}

## modify config
case ${CONFIG_ST} in
	"publish")
		cp -vf ${PUBLISH_CFG} ${CONFIG_FILE}
		;;
	"debug")
		cp -vf ${DEBUG_CFG} ${CONFIG_FILE}
		;;
esac
cd ..

## envalue
ln -s ${PUBLISH_DIR}/${GIT_TAG} ${USED_DIR}
cd ${ROOT_DIR}

## clear
rm -rf ${TEMP_DIR}
