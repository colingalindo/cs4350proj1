#!/bin/bash

DATABASEFILE="databaseFile.txt"
IFS=":"

function findRecord() {
	echo "Enter what to search for: "
	read SEARCH
	grep -i $SEARCH $DATABASEFILE
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

function updateMenu {
	while [ ! "$INPUT" = "e" ] ; do
		echo "What would you like to change"
		echo "(a) Name"
		echo "(b) Address"
		echo "(c) Phone"
		echo "(d) email"
		echo "(e) Nothing quit"
		read INPUT
		case "$INPUT" in
			"a" | "A" )
				echo "Enter new name"
				read NAME
				;;
			"b" | 'B' )
				echo "Enter new address"
				read ADDRESS
				;;
			"c" | 'C' )
				echo "Enter new phone"
				read PHONE
				;;
			"d" | 'D' )
				echo "Enter new email"
				read EMAIL
				;;
			"e" | 'E' )
				;;
			* )
				echo "Invalid Input"
		esac
	done
		#Sets input back to nothing so it wont affect the other menus
		INPUT=' '
			
}

function updateRecord {
	echo "Which Record would you like to update: "
	read SEARCH
	temp=0
	while [ ! $temp -eq 1 ] ; do	
		
		#finds how many search results are found
		temp=$(grep -ci $SEARCH $DATABASEFILE)

		if [ $temp -gt 1 ]; then
			grep -i $SEARCH $DATABASEFILE
			echo "Found multiple Records please be more specific next time."
			temp=1
		elif [ $temp -eq 0 ]; then
			echo "Nothing Found!"
			temp=1
		else 
			#this finds the line in the file and then askes you which variable you want to change.
			grep -i $SEARCH $DATABASEFILE
			STR=$(sed -n $temp'p' $DATABASEFILE)
			#IFS=':'
			set $STR
			NAME=$1
			ADDRESS=$2
			PHONE=$3
			EMAIL=$4
			
			#Calls on the update menu to ask what the user would like to update.
			updateMenu	
			#REMOVES WHAT YOU searched for so it can be replaced with a new input
			grep -v "$SEARCH" $DATABASEFILE>dbs1	
			cat dbs1>$DATABASEFILE
			rm dbs1
	
			#adds the change to the output file
			echo "$NAME:$ADDRESS:$PHONE:$EMAIL" >> $DATABASEFILE
			echo "Record Updated!!"


		fi
		
	done
}
	

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
	echo "	(f) Show all records"
	echo "	(e) Quit"

}

function showRecords {
	echo ' '
	cat $DATABASEFILE
	echo ' '
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
		"a" | 'A' )
			findRecord
			;;
		"b" | 'B' )
			addRecord
			;;
		"c" | 'C' )
			updateRecord
			;;
		"d" | 'D' )
			removeRecord
			;;
		"f" | 'F' )
			showRecords
			;;
		"e" | 'E' )
			IFS=" "
			#exit
			;;
		* )
			echo "Invalid Input"
	esac
done
