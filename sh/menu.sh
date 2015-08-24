#!/bin/bash
# this is the menu
menu()
{
	echo "====================================================";
	echo "|             1. TIGER BUILD SCRIPT                |";
	echo "|--------------------------------------------------|";
	echo "| [0]. exit                                        |";
	echo "| [1]. source build/envsetup.sh                    |";
	echo "| [21]. choosecombo release sp8825eaplus userdebug |";
	echo "| [22]. choosecombo release sp8825eaplus user      |";
	echo "| [3]. make -j32                                   |";
	echo "| [4]. make clean                                  |";
	echo "| [51]. build userdebug                            |";
	echo "| [52]. build user                                 |";
	echo "| [6]. enter terminal mode                         |";
	echo "====================================================";
	#echo "Please input your choice:";
	#echo "4. cp buildimg to download dir"
}

buildlog()
{
	echo "===================================================";
	echo "|             2. TIGER BUILD MAKE                 |";
	echo "|-------------------------------------------------|";
	echo "| [0]. go back to main menu                       |";
	echo "| [1]. Output build log to file build.log         |";
	echo "| [2]. Just build                                 |";
	echo "===================================================";
	read -p "Please input your choice:" ch;
	echo "$ch"
	while [ -n "$ch" ]; do
		case $sh in
			1) echo "make -j32 > build.log 2>&1";
				make -j32 > build.log 2>&1; break;;
			2) echo "make -j32";
				make -j32; break;;
			*) echo "input error, just as default[2]"
				make -j32; break;;
		esac
	done
}

welcome()
{
	menu;
	read -p "Please input your choice:" cmd;
	echo "$cmd"
	while [ -n "$cmd" ]; do
		case $cmd in
			0) echo "exit system"; exit 0;;
			1) echo "source build/envsetup.sh";
				source build/envsetup.sh;
				welcome; break;;
			21) echo "choosecombo release sp8825eaplus userdebug";
				choosecombo release sp8825eaplus userdebug;
				echo "test out: [${OUT}]";
				welcome; break;;
			22) echo "choosecombo release sp8825eaplus user";
				choosecombo release sp8825eaplus user;
				echo "test out: [${OUT}]";
				welcome; break;;
			3) 	#buildlog;
				echo "make -j32";
				make -j32;
				welcome; break;;
			4) echo "make clean";
				make clean;
				welcome; break;;
			51) echo "build debug";
				source build/envsetup.sh;
				choosecombo release sp8825eaplus userdebug;
				echo "test out: [${OUT}]";
				make clean;
				make -j32;
				echo "**********Auto make finished!!!***********";
				welcome; break;;
			52) echo "build user";
				source build/envsetup.sh;
				choosecombo release sp8825eaplus user;
				echo "test out: [${OUT}]";
				make clean;
				make -j32;
				echo "**********Auto make finished!!!***********";
				welcome; break;;
			6) echo "Enter terminal mode";
				read -p "zhangguangde@zstar: ${PWD}$ " sys_cmd;
				#exec $sys_cmd;
				$sys_cmd;
				if (($?)); then echo failed; else echo OK; fi
				welcome; break;;
			*) echo "Input error";
				welcome; break;;
		esac
	done
}

dobuild()
{
	echo "===================================================";
	echo "|                    NOTICE                       |";
	echo "|-------------------------------------------------|";
	echo "|    This is just for set env, choose version,    |";
	echo "| make, not use for module build.                 |";
	echo "===================================================";
	read -p "Press any key to continue." var;
	#cat mv2down.sh;
	welcome;
}
dobuild;

