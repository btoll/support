#!/bin/bash

EXPECTED_ARGS=2
# get preset environment variable or set a default location
DEFAULT_SDK_LOCATION=${EXT_SDK:-"/usr/local/www/extjs/builds"}
VER=$2
# extract the first character of the Ext version
MACRO=${VER:0:1}
#DEBUG_SCRIPT="ext-all-debug-w-comments.js"
DEBUG_SCRIPT="ext-debug.js"

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: $0 <dir_name> <ext_version>"
    exit 1
else
    if [ -d $1 ]; then
        echo "Warning: Directory already exists, exiting..."
        exit 1
    else
        # create the new ticket dir
	mkdir -m 0755 -p $1

        # link to the SDK

	#uncomment the following line if you have multiple SDK locations
        #read -p "Location of SDK: [$DEFAULT_SDK_LOCATION] " SDK
        SDK=${SDK:-$DEFAULT_SDK_LOCATION}

        ADAPTER="<script type=\"text/javascript\" src=\"$SDK/$VER/adapter/ext/ext-base.js\"></script>\n"

        # if the version number is 2.x then change the debug script
        # if the version number is 4.x then don't include the adapter script
        case $MACRO in
            2)
                DEBUG_SCRIPT="ext-all-debug.js"
                ;;
            4)
                ADAPTER=""
                ;;
        esac

        if [ $MACRO -lt 4 ]; then
            ONREADY="Ext.onReady(function () {\n});"
        else
            ONREADY="Ext.application({\n\tname: 'TEST',\n\n\tlaunch: function () {\n\t}\n});"
        fi

        HTML="<html>\n<head>\n<title>$1</title>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"$SDK/$VER/resources/css/ext-all.css\" />\n$ADAPTER<script type=\"text/javascript\" src=\"$SDK/$VER/$DEBUG_SCRIPT\"></script>\n<script type=\"text/javascript\">\n$ONREADY\n</script>\n</head>\n\n<body>\n</body>\n</html>"

        # echo HTML honoring the new lines (-e flag)
        echo -e $HTML > $1/index.html

        #uncomment the statement below if you have multiple SDK locations
        #echo ""
	echo "Created new ticket in directory $1."
        echo "Linked to SDK location at $SDK."
        exit 0
    fi
fi
