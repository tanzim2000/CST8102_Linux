#!/bin/bash -a
#
#
#
#
lineLength=$(tput cols)
read username < <(whoami)
read usernameFull < <(grep $(whoami) /etc/passwd | cut -d':' -f'5' | cut -d',' -f'1')
clRED='\033[0;31m'
clNULL='\033[0m'
printmenu () {
	./shapes.sh line $lineLength '#'
	echo
	echo "Enter your choice:"
	echo "(P)rint out a list of users"
	echo "(L)ist the user groups"
	echo "(A)dd a new user"
	echo "(C)reate a welcome file for a user"
	echo "(Q)uit"
	echo
	./shapes.sh line $lineLength '#'
	echo
	echo -n  enter your choice: 
	read option
	echo
	inputEvaluationCase
}
quit() {
	clear
	./shapes.sh line $lineLength '#'
	echo
	read -p "Are you sure? [Y/N]:	" exitChoice
	echo
	./shapes.sh line $lineLength '#'
	case $exitChoice in
		[Yy]*)
			exit
			;;
		[Nn]*)
			clear
			printmenu
			;;
		*)

	esac
}
pause() {
	read -p "Press [ENTER] to continue or [Q] to quit: " enter
	case $enter in
		[Qq])
			quit
			;;
		*)
			clear
			printmenu
			;;
	esac
}
newuseradd() {
	./shapes.sh l $lineLength '#'
                        echo
                        read -p "Enter a login name for the user to be added:	" newuser
                        echo
                        if id "$newuser" >/dev/null 2>&1; then
                                echo 1>&2 "User $newuser already exists, try another username"
                                echo
                                newuseradd
                        else
                                sudo addUser $newuser
                        fi
                        echo
                        ./shapes.sh l $lineLength '#'
			echo
                        pause

}
createWelcome() {
	./shapes.sh l $lineLength '#'
	read -p "Enter a user name or [LISTUSER] for a list of the user or m to go back to printmenu : " welcomeuser
	echo
	if [[ $welcomeuser =~ 'LISTUSER' ]]
	then
		./shapes.sh l $lineLength '-'
		echo -e "\e[1m	User Name	| User Full Name \e[0m"
		awk -F: '{ if ($3 >= 1000 && $3 <= 60000) { print ("	"$1"	| "$5 ) } }' /etc/passwd | cut -d',' -f'1'
		./shapes.sh l $lineLength '-'
		echo
		createWelcome
	elif [[ $welcomeuser =~ [Mm] ]]
	then
		clear
		printmenu
	elif id "$welcomeuser" >/dev/null 2>&1; then
		read -p "Would you like to create a custom text? [Y/N]	" customtxtdecision
		case $customtxtdecision in
			[Yy]*)
				echo
				echo Start typing your custom text
				./shapes.sh l $lineLength
				read customtxt
				echo
				echo $customtxt > welcometxt.txt
				sudo mv welcometxt.txt ../../../../../../home/$welcomeuser
				echo
				echo "File Successfully Created"
				;;
			[Nn]*)
				customtxt="Welcome to the system $welcomeuser"
				echo $customtxt > welcometxt.txt
				sudo mv welcometxt.txt ../../../../../../home/$welcomeuser
				echo
				echo "File Successfully Created with default message"
				;;
		esac
		echo
		./shapes.sh l $lineLength '#'
		echo
		pause
	fi
}
inputEvaluationCase() {
		case $option in
        	[Pp])
                	./shapes.sh l $lineLength '#'
                	echo
                	echo Actual Users of the System: 
                	awk -F: '{ if ($3 >= 1000 && $3 <= 60000) { print ($1": "$5) } }' /etc/passwd | cut -d',' -f'1'
                	echo
                	./shapes.sh l $lineLength '#'
                	echo
                	pause
                	;;
		[Qq])
			quit
			;;
        	[Ll])
                	./shapes.sh l $lineLength '#'
                	echo
                	echo User Groups in the System
                	echo -e "[An ${clRED}*${clNULL} means indecates the group is not a personal group]"
                	echo
			./shapes.sh line $lineLength '#'
			echo
                	groupAmount=$(nawk -F: '{if ($3 >= 1000 && $3 <= 60000) { print $1 }}' /etc/group | wc -w)
                	groupArray=$(nawk -F: '{if ($3 >= 1000 && $3 <= 60000) { print $1 }}' /etc/passwd)
                	for ((index = 1000; index <= (1000 + $groupAmount); index++ ))
                	do
                        	targetGroup=$(getent group $index | cut -d ':' -f 1)
                        	if [[ ${groupArray[*]} =~ ${targetGroup} ]]
                        	then
                        	        echo $targetGroup
                        	else
                        	        echo -e "${clRED}*$targetGroup ${clNULL}"
                	        fi
                	done
                	echo
                	./shapes.sh l $lineLength '#'
                	echo
                	pause
                	;;
		[Aa])
			newuseradd
			;;
		[Cc])
			createWelcome
			;;
        	*)
	                clear
			echo 1>&2 "$0: Option  wasn't recognized"
	                printmenu
	                ;;
	esac
}
clear
./shapes.sh l $lineLength '#'
echo
echo "Hello $usernameFull"
echo "Welcome to the System Administration Menu"
echo
./shapes.sh l $lineLength '#'
echo "Note that there are administrative functions that will"
echo "ask for an administrator password."
printmenu
