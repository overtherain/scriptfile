#!/bin/bash
branch=`git branch | grep -i '* ' | awk '{print $2}'
# 恢复没有添加的文件
echo "Step 1. 恢复没有添加的文件"
git apply ${branch}_not_add_patch.diff
# 恢复修改的文件
echo "Step 2. 恢复修改的文件"
git apply ${branch}_modify_patch.diff

echo "恢复好了"

