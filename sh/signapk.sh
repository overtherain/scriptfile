#!/bin/bash
in=$1
out=$2
cmd="java -jar $HOME/shell/software/signapk/signapk.jar -w $HOME/shell/software/signapk/testkey.x509.pem $HOME/shell/software/signapk/testkey.pk8 $in $out"
$cmd
