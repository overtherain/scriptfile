#!/bin/bash

###########################################################################
#
# Authors: Jesús Espino García & Lucas García
# Email: jespino@imap.cc
# Date: 31/05/2004
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
###########################################################################

# If the config file not exist, load the default parameters

VERSION="0.1"

#可以在本地存在一个配置文件，没有也没有关系，我现在就没有建，脚本会自动判断的。
CONFIG_FILE="/etc/apt-axel.conf";

#注意，如下命令统统在tmp目录下面执行。
cd /tmp

#如果在本地有了配置，就加载，我现在没有这个配置，当然不加载
if [ -f $CONFIG_FILE ]; then
  . $CONFIG_FILE 
else
#配置都下载下面几个语句里面了。
    # Verbose TRUE or FALSE
  VERBOSE="FALSE"

  # Conections
#默认多线程的连接数
  CONNECTIONS=8

  # Servers
#服务器路径，与第一部分里面那个基本一致，但是注意这里后面是有 ubuntu 这个子目录的。
   server1="http://archive.ubuntu.com/ubuntu/"
fi

# Set the package variable to be global
package="";

# Show the help
#函数：显示一个帮助
mostrar_ayuda() {
  echo "Usage: apt-axel <option> <package>";
  echo "";
  echo "Options:";
  echo "  install - Install new packages (paquete es libc6 y no libc6.deb)";
  echo "  upgrade - Do a software upgrade";
  echo "  dist-upgrade - Do a distribution upgrade, see apt-get(8)";
  echo "  --version - Print the current version of apt-axel";
  echo "  --help - Show this help";
  echo "";
}

# Get a package from the ftp server
#函数：这个就是多线程去取软件包的。
get_package() {

#函数中的函数
  descargar() {
    echo "===========BEGIN DOWNLOAD ${server1}${url} ==to = /tmp/${archivo}======"
    # Check the $VERBOSE variable and the filesize, if the filesize is lower than 200K will use only 4 conections
    # And if the $VERBOSE variable is TRUE, then print the axel output
      if [ $size -gt 200000 ]; then
        echo "axel -n $CONNECTIONS $server1$url "
        axel -n $CONNECTIONS $server1$url 
      else
        echo "axel -n 4 $server1$url "
        axel -n 4 $server1$url 
      fi
    echo "===========END DOWNLOAD ${server1}${url}========"
    
  }

  # Getting data
#用apt-cache找到某个指定的软件的具体的url位置.
  url=$(apt-cache show $package | grep ^Filename: | sed s/^Filename:\ //)
  echo "URL:[${url}]"

#存下来的文件名称
  archivo=$(echo "$url" | sed s/^.*$package/$package/)
  echo "archivo:[${archivo}]"
  pkgstatus=$(dpkg -s $package 2> /dev/null | grep ^Status: | grep -v "not-installed")
  echo "pkgstatus:[${pkgstatus}]"

#MD5校验值，取下来以后，当然要看看包有没有损坏啦
  md5sum=$(apt-cache show $package | grep ^MD5sum: | sed s/^MD5sum:\ //)
  echo "md5sum:[${md5sum}]"
  size=$(apt-cache show $package | grep ^Size: | sed s/^Size:\ //)
  echo "size:[${size}]"

  # Downloading the package
#看看之前是否已经下载过了，即本地的cache里面是否已经存在
  if [ -f /var/cache/apt/archives/$archivo ]; then
    echo -n "Package already downloaded. Checking md5sum of $package package: "
#如果md5不匹配，还是要删除再重新去下载
    while [ $md5sum != $(md5sum /var/cache/apt/archives/$archivo | sed s/\ .*$//) ]; do 
      echo "incorrect"
      echo "Downloading again $package package."
      rm -f /var/cache/apt/archives/$archivo
      descargar
    done
    echo "correct"

#如果本地没有cache，去下载吧，没什么可犹豫的
  else 
      descargar
  fi

  # Move the file to /var/cache/apt/archives
#如果下载成功了，把文件移到cache目录下面去。
  if [ -f /tmp/${archivo} ]; then
    if [ $md5sum == $(md5sum /tmp/$archivo | sed s/\ .*$//) ]; then
      mv -f /tmp/$archivo /var/cache/apt/archives/
    fi
  fi
}

#下面几个函数不说，大家一看函数名字也知道干什么的了
pkg_install() {
  echo "want to install [$1]"
  for package in $(apt-get -s install $1 | grep ^Inst\ | sed s/^Inst\ // | sed s/\ .*$//); do
    echo "package:[${package}]"
    get_package
  done
  apt-get -y install $1
}

upgrade() {
  for package in $(apt-get -s upgrade | grep ^Inst\ | sed s/^Inst\ // | sed s/\ .*$//); do
    get_package
  done
  apt-get -y upgrade
}

dist_upgrade() {
  for package in $(apt-get -s dist-upgrade | grep ^Inst\ | sed s/^Inst\ // | sed s/\ .*$//); do
    get_package
  done
  apt-get -y dist-upgrade
}


#
# Main program
#
if [ `id -u` != 0 ]; then
  echo "You must be root to run this command."
else
  case $1 in
    install) pkg_install $2;;
    upgrade) upgrade;;
    dist-upgrade) dist_upgrade;;
    (--version) echo "Current Version: $VERSION";;
    (--help | -h) mostrar_ayuda;;
    *) mostrar_ayuda;;
  esac
fi