#!/bin/bash
# 恢复没有添加的文件
echo "Step 1. 恢复没有添加的文件"
git apply not_add_patch.diff
# 恢复修改的文件
echo "Step 2. 恢复修改的文件"
git apply modify_patch.diff

echo "恢复好了"

