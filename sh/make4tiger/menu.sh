#!/bin/bash
# this is the menu
menu()
{
	echo "===================================================";
	echo "|             1. TIGER BUILD SCRIPT               |";
	echo "|-------------------------------------------------|";
	echo "| [0]. exit                                       |";
	echo "| [1]. source build/envsetup.sh                   |";
	echo "| [2]. choosecombo release sp8825eaplus userdebug |";
	echo "| [3]. make -j32                                  |";
	echo "| [4]. make clean                                 |";
	echo "===================================================";
	echo "Please input your choice:";
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
	echo "Please input your choice:";
	read ch;
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
	read cmd;
	while [ -n "$cmd" ]; do
		case $cmd in
			0) exit 0;;
			1) echo "source build/envsetup.sh";
				source build/envsetup.sh;
				welcome; break;;
			2) echo "choosecombo release sp8825eaplus userdebug";
				choosecombo release sp8825eaplus userdebug;
				welcome; break;;
			3) 	buildlog;
				welcome; break;;
			4) echo "make clean";
				make clean;
				welcome; break;;
			*) echo "Input error";
				welcome; break;;
		esac
	done
}

welcome;
