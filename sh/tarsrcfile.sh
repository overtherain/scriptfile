#!/bin/bash
#echo "srcpack [path][jobs][packagename][type]";
if [ -n "$1" ]; then
	fPath=$1;
	case $1 in
		h) echo "srcpack [path][jobs][packagename][type]";
			echo "srcpack ~/ 100 package.tar.gz tar"
			exit 0;;
		v) echo "srcpack v1.0";
			echo "Design by Gdz";
			echo "Email:zgd_521@126.com";
			exit 0;;
	esac
else
	read -p "Input filepath:" fPath;
fi
if [ -n "$2" ]; then
	jCount=$2;
else
	read -p "Input number of Jobs:" jCount;
fi
if [ -n "$3" ]; then
	pName=$3;
else
	read -p "Compass package name:" pName;
fi
if [ -n "$4" ]; then
	pType=$4;
else
	read -p "Compass package type:" pType;
fi
if [ -n "$5" ]; then
	pVar=$5;
else
	read -p "Compass package var:" pVar;
fi

echo ${fPath};
echo ${jCount};
echo ${pName};
echo ${pType};
echo ${pVar};

find ${fPath} -name out -prune -o -name .repo -prune -o -name .git -prune -o -type f -iregex '.*\.\(c\|h\|cpp\|S\|java\|xml\|sh\|mk\|aidl\)' > filelist.log
cat filelist.log | xargs -n ${jCount} ${pType} ${pVar} ${pName}
rm filelist.log
#${pType} ${pVar} ${pName} ${fPath}
