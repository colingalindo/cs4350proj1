#!/bin/bash

DATABASEFILE="databaseFile.txt"

#function findRecord {
#}

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
}

#function updateRecord {
#}

#function removeRecord {
#}

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
	echo "Name:Address:Phone:Email" >> $DATABASEFILE
fi

INPUT=""

while [ ! "$INPUT" = "e" ] ; do
	printMenu
	read INPUT
	case "$INPUT" in
		"a" )
			addRecord
			;;
		"b" )
			;;
		"c" )
			;;
		"d" )
			;;
	esac
done
