#!/bin/bash
if [ -n $1 ]; then
	img=$1;
	echo "Image is: $1"
else
	read -p "Input you image" img;
	echo "$img"
fi
identify -verbose ${img}
