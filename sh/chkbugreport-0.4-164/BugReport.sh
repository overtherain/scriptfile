#!/bin/sh
java -jar ~/shell/sh/chkbugreport-0.4-164/chkbugreport-0.4-164.jar "${PWD}/bugreport.log"
mv bugreport.log_out bugreport_${datestr}_out
