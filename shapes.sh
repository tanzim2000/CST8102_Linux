#!/bin/bash -u
#shapes.sh, Version 1.0
#
#this program will take 2 mandatory arguements and 1 optional argument and print square,
#line and triangle of the size the user will input.
#3rd arguement is the fill charecter that'll create the shape. By default it's '*'

shape=$1
size=$2

#filtering out the input
if [[ $# == 3 ]]
then
	fill=$3
elif [[ $# < '2' || $# > '3' ]]
then
	echo -n 1>&2 "$0: Error: 2 or 3 number of arguements expected; found $# in ($*)"
	exit
else
	fill='*'
fi

#validating size
if [[ $size -gt $(tput cols) ]]
then
	echo -n 1>&2 "$0: Error: the size is bigger than the window width $(tput cols); found $2 in ($*)"
	exit
fi

#function to print Square
printSquare() {
	for (( height=0 ; height < $size ; height++ ))
	do
		for (( width=0 ; width < $size ; width++ ))
		do
			echo -n "$fill"
		done
		echo
	done
}

#function to print Line
printLine() {
	for (( width=0; width < $size ; width++ ))
	do
		echo -n "$fill"
	done
	echo
}

#function to print Triangle
printTriangle() {
	for (( height=0 ; height <= $size ; height++ ))
	do
		for (( width=0 ; width <= height ; width++ ))
		do
			echo -n "$fill"
		done
	echo
done
}

case $shape in
	[Ll] | [Ll][Ii][Nn][Ee])
		printLine
		;;
	[Ss] | [Ss][Qq][Uu][Aa][Rr][Ee])
		printSquare
		;;
	[Tt] | [Tt][Rr][Ii][Aa][Nn][Gg][Ll][Ee])
		printTriangle
		;;
	*)
		echo 1>&2 "$0: Error: Square, Triangle, Line expected; found $2 in ($*)"
		;;
esac
