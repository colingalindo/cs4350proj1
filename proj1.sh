#!/bin/bash

DATABASEFILE="databaseFile.txt"
IFS=":"

function findRecord() {
	echo "Enter what to search for: "
	read SEARCH
	grep $SEARCH $DATABASEFILE
	if [ $? = 1 ]; then
		echo "Nothing Found!"
	fi
}

function addRecord {
	echo "Enter the person's name: "
	read NAME
	echo "Enter the person's address: "
	read ADDRESS
	echo "Enter the person's phone number: "
	read PHONE
	echo "Enter the person's email: "
	read EMAIL
	echo "$NAME:$ADDRESS:$PHONE:$EMAIL" >> $DATABASEFILE
	echo "Record added"
}

#function updateRecord {
#}

function removeRecord {
	echo "Enter the record to be removed: "
	read REMOVE
	grep $REMOVE $DATABASEFILE
	if [ $? = 1 ]; then
		echo "The record cannot be found."
	else
		grep -v "$REMOVE" $DATABASEFILE>dbs1
		echo "The record has been deleted."
	fi
	cat dbs1>$DATABASEFILE
	rm dbs1
}

function printMenu {
	echo "Welcome to my contact database, please select from the following menu:"
	echo "	(a) Find a record"
	echo "	(b) Add a new record"
	echo "	(c) Update a record"
	echo "	(d) Remove a record"
	echo "	(e) Quit"

}


if [ ! -e "$DATABASEFILE" ] ; then
	echo "Creatineg database file" . $DATABASEFILE
	touch $DATABASEFILE
fi

INPUT=""

while [ ! "$INPUT" = "e" ] ; do
	printMenu
	read INPUT
	case "$INPUT" in
		"a" )
			findRecord
			;;
		"b" )
			addRecord
			;;
		"c" )
			;;
		"d" )
			removeRecord
			;;
		"e" )
			IFS=" "
			exit
			;;
		* )
			echo "Invalid Input"
	esac
done
