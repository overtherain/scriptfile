#!/bin/bash
cd
source ~/shell/lenv
function update_branch()
{
	echo "[gdz->============>]# cd $1"
	cd $1
	echo "[gdz->============>]# git pull"
	git pull
}

# update_branch ${t8291cmcc}
# update_branch ${t8291mp}
# update_branch ${t8381cmcc}
# update_branch ${t8381mp}
# update_branch ${t8253cmcc}
# update_branch ${t8253mp}
# update_branch ${t8521cmcc}
# update_branch ${t8521mp}
# update_branch ${t8321cmcc}
# update_branch ${t8321mp}
# update_branch ${t8391cmcc}
# update_branch ${t8391mp}
# update_branch ${t8392cmcc}
# update_branch ${t8392cmccwifi}
# update_branch ${t8392emp}
# update_branch ${t8391scmcc}
# update_branch ${t8392cmp}
# update_branch ${t8601acmcc}
# update_branch ${t8601amp}
# update_branch ${t8620a}
# update_branch ${t207}
# update_branch ${t8651a}
# update_branch ${t8631a}
# update_branch ${t8681a}
# update_branch ${t8660a}
# update_branch ${t8681atest}
# update_branch ${t8681acmcc}
# update_branch ${t8701acmcc}
# update_branch ${t8701c}
# update_branch ${t8702a}
# update_branch ${t8681b}
# update_branch ${t8721a}
update_branch ${t8681bmp}
#update_branch ${t8701c}
update_branch ${t8701cmp}
update_branch ${t8702amp}
# update_branch ${t8721b}
#update_branch ${t8702b}
update_branch ${t8702bmp}
#update_branch ${t8771a}
update_branch ${t8771amp}
#update_branch ${t8801a}
update_branch ${t8801amp}
update_branch ${t8821a}
update_branch ${t8682b}
update_branch ${t8861a}
echo "[gdz->============>]# Update branch.git finished!!!!!!!"
