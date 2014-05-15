#!/bin/bash
# 当前备份目录
cur=${PWD}

# 创建临时工作目录
tmp=${HOME}/TEMP
echo "Step 1. 创建临时目录，用来备份文件"
st1="mkdir -p ${tmp}"
echo $st1
mkdir -p ${tmp}

# 把out目录暂时移动到上一级目录
echo "Step 2. 移动out目录到临时目录"
st2="mv out ${tmp}/"
echo $st2
mv out ${tmp}/
mv backup.sh ${tmp}/
mv restore.sh ${tmp}/

# 把所有新增文件添加跟踪
echo "Step 3. 把所有没有跟踪信息的文件添加跟踪，以方便备份"
st3="git status -s | grep '?? ' | awk '{print $2}' | xargs git add"
echo $st3
git status -s | grep '?? ' | awk '{print $2}' | xargs git add

# 备份新增文件
echo "Step 4. 进行二进制备份，备份新增文件到not_add_patch.diff文件"
st4="git diff --binary --cached > not_add_patch.diff"
echo $st4
git diff --binary --cached > not_add_patch.diff

# 恢复add过的文件
echo "Step 5. 恢复初始状态"
st5="git reset"
echo $st5
git reset

# 备份修改的文件
echo "Step 5. 进行二进制备份，备份新增文件到modify_patch.diff文件"
st5="git diff --binary > modify_patch.diff"
echo $st5
git diff --binary > modify_patch.diff

# 重新把out放回原来目录
echo "Step 6. 恢复out目录"
st6="mv ${tmp}/out ./"
echo $st6
mv ${tmp}/out ./
mv ${tmp}/backup.sh ./
mv ${tmp}/restore.sh ./

# 删除临时目录
echo "Step 7. 删除临时目录"
st7="rm -rf ${tmp}"
echo $st7
rm -rf ${tmp}

# 备份结束，请保存这个项目生成的文件
echo "备份结束，请保存这个项目生成的not_add_patch.diff文件和modify_patch.diff文件"

