#!/bin/bash
cd ${MSOFT}/eclipse.php
export JAVA_HOME=/usr/lib/jvm/openjdk-7-amd64
export PATH=${JAVA_HOME}/bin:$PATH
./eclipse &
