#!/bin/bash
########################################################
# self define
export WORKDIR=${HOME}/android
export JAVA_DIR=/usr/lib/jvm/java-6-sun
export BRANCH_DIR=${HOME}/develop/branch.git
export JAVA_HOME=$JAVA_DIR
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export SDK_HOME=$WORKDIR/android-sdk-linux
export NDK_HOME=$WORKDIR/android-ndk-linux
export COCOS2DX_HOME=${BRANCH_DIR}/cocos2d-x
export NDK_ROOT=${NDK_HOME}
export ECLIPSE_HOME=$WORKDIR/eclipse

# self script path
export MSHELL=${HOME}/shell

