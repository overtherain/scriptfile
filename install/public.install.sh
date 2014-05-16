#!/bin/bash
ln -s ${MSHELL}/sh/apt-axel.sh ${MSHELL}/run/apt-axel

ln -s ${MSHELL}/sh/screenshot ${MSHELL}/run/screenshot

## create daliy.push.report
ln -s ${MSHELL}/sh/daliy.report.sh ${MSHELL}/run/daliy.push.report
ln -s ${MSHELL}/sh/daliy.report.daemon.sh ${MSHELL}/run/daliy.push.daemon

## display mount as tab
ln -s ${MSHELL}/sh/mounttab.sh ${MSHELL}/run/mounttab

## Show image inforation
ln -s ${MSHELL}/sh/showexif.sh ${MSHELL}/run/showexif
ln -s ${MSHELL}/sh/showimage.sh ${MSHELL}/run/showimage

## JAR package self command
ln -s ${MSHELL}/sh/jspwar.sh ${MSHELL}/run/jspwar

## Do monkeytest
ln -s ${MSHELL}/sh/monkeytest.sh ${MSHELL}/run/monkeytest

ln -s ${MSHELL}/sh/gitzip.sh ${MSHELL}/run/gitzip

# package version download files
ln -s ${MSHELL}/sh/tarsrcfile.sh ${MSHELL}/run/srcpackage
ln -s ${MSHELL}/sh/cp_package.sh ${MSHELL}/run/verpack

ln -s ${MSHELL}/sh/rm_svn.sh ${MSHELL}/run/rm_svn
ln -s ${MSHELL}/sh/superrm.sh ${MSHELL}/run/superrm

ln -s ${MSHELL}/bin/QIpmsg ${MSHELL}/run/ipmsg

ln -s ${MSHELL}/sh/menu.sh ${MSHELL}/run/menu

