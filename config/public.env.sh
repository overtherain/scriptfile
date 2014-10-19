#!/bin/bash
CL_RED="\033[31m";
CL_GRN="\033[32m";
CL_YLW="\033[33m";
CL_BLU="\033[34m";
CL_MAG="\033[35m";
CL_CYN="\033[36m";
CL_RST="\033[0m";
#######################################################
# help menu
#######################################################
alias ghelp="echo \"gl=git log --name-only --color=auto\"
echo \"gd=git diff --color=auto\"${CL_RST}
echo \"gb=git branch\"
echo \"gbr=git branch -r\"
echo \"gc=git checkout\"
echo \"gp=git pull\"
echo \"gu=git push\"
echo \"gs=git status\"
echo \"gss=git status -s\"
echo \"gw=git whatchanged\"
echo \"gcls=git status -s | grep \"??\" | awk '{print $2}' | xargs rm -rvf\""
#
#######################################################
# some git short cmd
#######################################################
alias gl="git log --name-status --color=auto --graph"
alias ga="git add"
alias gd="git diff --color=auto"
alias gb="git branch"
alias gc="git checkout"
alias gp="git pull"
alias gu="git push"
alias gs="git status"
alias gw="git whatchanged"
alias gss="git status -s"
alias gbr="git branch -r"
alias gba="git branch -a"
alias gcfg="git config -l"
alias gcls="git status -s | grep \"??\" | awk '{print $2}' | xargs rm -rvf"
#
#######################################################
# some adb short cmd
#######################################################
alias adbs="adb shell"
alias adbd="adb devices"
alias adbr="adb reboot"
alias adbcls="adb logcat -c"
alias adblog="adb logcat -v threadtime"
alias adbreport="adb shell bugreport"

#alias gu="git push"
#
# avalible for enviorment
export datestr="`date +%Y.%m.%d.%H.%M.%S`"
export zipstr="_gdz_`date +%Y.%m.%d_%H%M`"
export strlog="fatal|low mem|has died|activitymanager|keycode="
alias LANGUAGE="zh_CN.UTF-8"
alias LC_ALL="zh_CN.UTF-8"
#
#
# All branch finish
alias ll='ls -l'
alias lla='ls -Al'
alias dir='dir --color=auto'
