#!/bin/bash
dexFolder=${PWD}
dexFile=${dexFolder}/classes.dex
dexLib=${HOME}/shell/sh/dex2jar-0.0.9.15
rm -vf ${dexLib}/classes.dex
ln -s ${dexFile} ${dexLib}/classes.dex
cd ${dexLib}
./dex2jar.sh classes.dex
cp -vf classes_dex2jar.jar ${dexFolder}/
cd ${dexFolder}
jd-gui classes_dex2jar.jar &

