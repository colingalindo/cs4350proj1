#!/bin/bash

DATABASEFILE="databaseFile.txt"
OLD_IFS=$IFS
IFS=":"

function findRecord() {
	SEARCH=""
        while [ ! $SEARCH ] || [ $SEARCH  = " " ] ; do
                echo "Enter what to search for: "
                read SEARCH
                SEARCH=$(echo $SEARCH | sed -e 's/^ *//g' -e 's/ *$//g')
        done
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
			removeRecord $SEARCH

			#adds the change to the output file
			echo "$NAME:$ADDRESS:$PHONE:$EMAIL" >> $DATABASEFILE
			echo "Record Updated!!"


		fi
		
	done
}

function appendDatabase {
	echo "What database file you would like to add (include file extension): "
	read DB1
	if [ -f $DB1 ]
	then
		cat $DB1 >> $DATABASEFILE
		echo "The specified file has been appended to the database."
	else
		echo "The specified file cannot be found."
		return 1
	fi
}
	

function removeRecord {
        if [ "$1" = "" ]; then
                echo "Enter the record to be removed: "
                read -r REMOVE
        else
                REMOVE=$1
        fi

        REMOVE=$(grep -inm 1 -e $REMOVE $DATABASEFILE | sed 's/\([0-9]\)\:.*/\1/')

        if [ "$REMOVE" != "" ]; then
                sed -in $(expr $REMOVE)d $DATABASEFILE
                echo "The record has been deleted."
        else
                echo "The record cannot be found."
        fi
}


function printMenu {
	echo "Welcome to my contact database, please select from the following menu:"
	echo "	(a) Find a record"
	echo "	(b) Add a new record"
	echo "	(c) Update a record"
	echo "	(d) Remove a record"
	echo "	(f) Show all records"
	echo "        (e) Append another database to the current database"
	echo "	(g) Quit"

}

function showRecords {
	echo ' '
	cat $DATABASEFILE
	echo ' '
}

if [ ! -e "$DATABASEFILE" ] ; then
	echo "Creating database file" $DATABASEFILE
	touch $DATABASEFILE
fi

INPUT=""

while [ ! "$INPUT" = "g" ] ; do
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
			appendDatabase
			;;
		"g" | 'G' )
			IFS=$OLD_IFS
			#exit
			;;
		* )
			echo "Invalid Input"
	esac
done
