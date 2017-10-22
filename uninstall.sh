#!/bin/sh

BINARY_NAME="editSwiftScript"
BIN_SYMLINK_LOCATION="/usr/local/bin/$BINARY_NAME"
OPT_LOCATION="/usr/local/opt/$BINARY_NAME"

# ------

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

# ------

if [ -f "$BIN_SYMLINK_LOCATION" ]; then
	arrowEcho removing $BIN_SYMLINK_LOCATION
	rm $BIN_SYMLINK_LOCATION
	checkError
else
	arrowEcho skipping: $BIN_SYMLINK_LOCATION does not exist
fi

if [ -d "$OPT_LOCATION" ]; then
	arrowEcho removing $OPT_LOCATION/
	rm -rf $OPT_LOCATION
	checkError
else
	arrowEcho skipping: $OPT_LOCATION/ does not exist
fi

echo ✅  Done 