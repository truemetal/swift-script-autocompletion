#!/bin/sh

BINARY_NAME="editSwiftScript"
BIN_SYMLINK_LOCATION="/usr/local/bin/$BINARY_NAME"
OPT_LOCATION="/usr/local/opt/$BINARY_NAME"
OPT_BIN_LOCATION="$OPT_LOCATION/bin"

XCODE_TEMPLATE="script-edit-xcode-project"
SCRIPT="editSwiftScript.swift"

function arrowEcho {
	RIGHT_ARROW='\033[0;32m➤\033[0m'
	echo "$RIGHT_ARROW $@"
}

function errorEcho {
	echo "❌  $@"
}

function checkError {
	if [ ! $? -eq 0 ]; then
    	errorEcho failed
    	exit -1
	fi
}

# check pre-requsites

if [ ! -f "$SCRIPT" ]; then
	errorEcho script file does not exist
	exit -1
fi

if [ ! -d "$XCODE_TEMPLATE" ]; then
	errorEcho xcode template does not exist
	exit -1
fi

# -----

arrowEcho "remove existing installation (if any)"

if [ -f "$BIN_SYMLINK_LOCATION" ]; then
	rm $BIN_SYMLINK_LOCATION
	checkError
fi

if [ -d "$OPT_LOCATION" ]; then
	rm -rf $OPT_LOCATION
	checkError
fi

# -----

arrowEcho mkdir $OPT_LOCATION
mkdir "$OPT_LOCATION"
checkError

arrowEcho mkdir $OPT_BIN_LOCATION
mkdir "$OPT_BIN_LOCATION"
checkError

arrowEcho copying xcode project template to $OPT_LOCATION/$XCODE_TEMPLATE
cp -r "$XCODE_TEMPLATE" "$OPT_LOCATION/$XCODE_TEMPLATE"
checkError

arrowEcho copying $SCRIPT to $OPT_BIN_LOCATION
cp "$SCRIPT" "$OPT_BIN_LOCATION"
checkError

arrowEcho adding symlink to $BIN_SYMLINK_LOCATION
ln -s "$OPT_BIN_LOCATION/$SCRIPT" "$BIN_SYMLINK_LOCATION"
checkError

echo ✅  Done 
