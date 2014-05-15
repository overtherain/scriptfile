#!/bin/bash
if [ -n $1 ]; then
	img=$1;
	echo "Image is : ${img}";
else
	read -p "input image name" img;
	echo "img:$img"
fi
identify -format %[exif:*] ${img}
