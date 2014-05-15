#!/bin/bash
case $1 in
	h)
		echo "superrm [path]
	superrm path1
	is same to \"rm -rf path1\"";
	exit 1;
		;;
esac
mkdir -p t;
case $2 in
	d)
		/usr/bin/time rsync -a --delete t/ $1/;
		;;
	*)
		time rsync -a --delete t/ $1/;
		;;
esac
rm -rvf $1;
rm -rf t;
