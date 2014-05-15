#/bin/sh

#服务器的根地址，与 sources.list 里面那个地址的前半段一致。
DIST_URL=http://archive.ubuntu.com/
#CPU架构
DIST_ARCH=i386
#需要安装的包的类型，四个都写上吧
DIST_REPO="main multiverse universe restricted"
#服务器的目录
DIST_DIR=ubuntu/dists/hardy/
#本地保存的位置：放在这里是为了给apache2假设站点用。需要注意有合适的权限。
LOCAL_DIR=/var/www/

#进入本地目录
cd ${LOCAL_DIR}

#函数：取得某个子目录下面的文件， 带一个目录参数，比如  get_sub_dir main 
get_sub_dir(){
    echo handling $1 ...
    TMP_DIR=$1/binary-${DIST_ARCH}/
#将之前存在的目录统统删除，免得 axel 发现已经存在相同文件名后，取下来的文件会带 .0 .1 之类讨厌的后缀。
    rm -rf ${TMP_DIR}
    mkdir -p ${TMP_DIR}
    cd ${TMP_DIR}
#多线程去拉软件列表, 10 可以改小一点。
    axel -n 10 ${DIST_URL}${DIST_DIR}${TMP_DIR}Packages.bz2
}

#函数：刷新软件列表，其实就是循环调用上面的 get_sub_dir，分别取得  main multiverse restricted universe 四个目录的内容
refresh_package_list(){
  for repo in ${DIST_REPO} ; do
    cd ${LOCAL_DIR}${DIST_DIR}
    get_sub_dir ${repo}
  done
}

#如果之前已经有 ${DIST_DIR} 目录了，提醒一下
if [ -d ${DIST_DIR} ]; then
    echo dir: ${LOCAL_DIR}${DIST_DIR} already exists.
fi

#如果还没有，那么提醒并自动创建
if [ ! -d ${DIST_DIR} ] ; then
    echo "dir: ${LOCAL_DIR}${DIST_DIR} not exists, will create it."
    mkdir -p ${DIST_DIR} 
fi

#进入目录，相当于  cd /var/www/ubuntu/dists/hardy
cd ${DIST_DIR}

#函数：wget 单线程取一个文件，如果之前存在，删除之。
wget_file(){
  if [ -f $2 ]; then
    rm $2
  fi
  wget $1$2
}

#获取 Release 文件，里面有本Release的时间。这个文件很小，所以单线程。
#这里会先给你看看本地原来的Release[如果有的话]里面的时间，让你知道你现在的这个是什么时间更新的
#如果觉得没有必要，那么就不进行后面的更新了。
if [ -f Release ]; then
    echo "Release file exists, and Date is :"    
    grep Date: Release
    echo 
    echo -n "Are you going to continue ?[y/n/Y/N/yes/no]"
    read answer
    case ${answer} in
    n|N|no)
        exit 0
        ;;
    esac

fi

#获取两个文件
wget_file ${DIST_URL}${DIST_DIR} Release.gpg
wget_file ${DIST_URL}${DIST_DIR} Release

#给你看看新的Release的时间
grep Date: Release

#如果比上面一个原来的时间新，那就意味着需要更新了
#如果觉得没有必要，也可以自己放弃
echo -n "Will you refresh package list ?[y/n/Y/N/yes/no]"
read answer
case ${answer} in
Y|y|yes)
#如果要去更新，那么就去取软件列表回来，多线程
    refresh_package_list
    ;;
esac