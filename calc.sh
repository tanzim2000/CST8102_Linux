#!/bin/bash -u
PATH=/bin:/usr/bin ; export PATH
umask 022

firstNum=$1
secondNum=$3
operator=$2
if [[ $# == "3" ]]
then
	case $operator in
		+)
			result=$(($firstNum + $secondNum))
			;;
		-)
			result=$(($firstNum - $secondNum))
			;;
		/)
			if [[ $secondNum -eq "0" ]]
			then
				1>&2 "$0: Error: Expected dividend cannot be 0; found $secondNum in ($*)"
				exit
			else
				result=$(($firstNum / $secondNum))
			fi
			;;
		'*')
			result=$(($firstNum * $secondNum))
			;;
		%)
			result=$(($firstNum % $secondNum))
			;;
		*)
			1>&2 "$0: Error: Expected operator [ + - / * %]; found $operator in ($*)"
			exit
			;;
	esac
	echo "$USER the answer for $firstNum $operator $secondNum is $result"
else
	1>&2 "$0: Error: Three arguements expected; found $# in ($*)"
fi
