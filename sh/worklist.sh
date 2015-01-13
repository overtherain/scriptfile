#!/bin/bash
ps aux | grep -V 'grep' | grep 'make -j32'
