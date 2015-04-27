#!/bin/bash
param=$1
ps aux | egrep -v 'grep|worklist' | egrep "$param"
#ps aux | grep -v 'grep' | grep $param
#ps aux | grep -v 'grep' | grep 'make -j32' | awk '{print $1" "$7}'
#ps aux | grep -v 'grep' | grep 'make -j32' | awk '{print $1" "$7}'

