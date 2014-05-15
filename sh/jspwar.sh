#!/bin/bash
file=$1
in=/home/zhanggd/myproject/phrms/${file}/webapp/WebRoot
out=/home/zhanggd/myproject/phrms/PHR_SERVICE/phrtomcat/webapps
webbin=/media/develop/branch.git/myproject/phrms/PHR_SERVICE/phrtomcat/bin
cd ${webbin}
pwd
./shutdown.sh
cd ${in}
pwd
rm -rvf /home/zhanggd/myproject/phrms/PHR_SERVICE/phrtomcat/webapps/${file}
rm -rvf /home/zhanggd/myproject/phrms/PHR_SERVICE/phrtomcat/webapps/${file}.war
case ${file} in
	'PHRMS')
		#git checkout ./
		jar -cvf ${in}/../../out/${file}.war ./
		git apply ${in}/../../diff/context.diff
		jar -cvf ${out}/${file}.war ./
		;;
	*)
		jar -cvf ${out}/${file}.war ./
		cp -v ${out}/${file}.war ${in}/../../out/
		;;
esac
cd ${webbin}
pwd
./startup.sh
