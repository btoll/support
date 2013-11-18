#!/bin/bash

EXPECTED_ARGS=2
# get preset environment variable or set a default location (logical OR ----> ":-")
DEFAULT_BUILDS_LOCATION=${EXT_BUILDS:-"/usr/local/www/extjs/builds/"}
VER=$2

if [ "SDK" = $VER ]; then
    VER="extjs"
    DEBUG_SCRIPT="ext.js"
    # link to the SDK
    SDK=${EXT_SDK:-"/usr/local/www/SDK/"}
else
    # extract the first character of the Ext version
    MACRO_VER=${VER:0:1}

    DEBUG_SCRIPT="ext-debug.js"

    # link to the SDK
    # uncomment the following line if you have multiple SDK locations
    #read -p "Location of SDK: [$DEFAULT_SDK_LOCATION] " SDK
    SDK=${SDK:-$DEFAULT_BUILDS_LOCATION}

    # if the version number is 2.x then change the debug script
    # if the version number is 3.x then include the adapter script
    # don't change anything for 4.x or for SDK
    if [ $MACRO_VER -lt 4 ]; then
        DEBUG_SCRIPT="ext-all-debug.js"
        ADAPTER="<script type=\"text/javascript\" src=\"$SDK$VER/adapter/ext/ext-base.js\"></script>\n"
    fi
fi

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: $0 <ticket_dir_name> <ext_version>"
    exit 1
else
    if [ -d $1 ]; then
        echo "Warning: Directory already exists, exiting..."
        exit 1
    else
        # create the new ticket dir
	    mkdir -m 0755 -p $1

        ONREADY="Ext.onReady(function () {\n});"
#        if [ $MACRO_VER -lt 4 ]; then
#            ONREADY="Ext.onReady(function () {\n});"
#        else
#            ONREADY="Ext.application({\n\tname: 'TEST',\n\n\tlaunch: function () {\n\t}\n});"
#        fi

        HTML="<html>\n<head>\n<title>$1</title>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"$SDK$VER/resources/css/ext-all.css\" />\n$ADAPTER<script type=\"text/javascript\" src=\"$SDK$VER/$DEBUG_SCRIPT\"></script>\n<script type=\"text/javascript\">\n$ONREADY\n</script>\n</head>\n\n<body>\n</body>\n</html>"

        # echo HTML honoring the new lines (-e flag)
        echo -e $HTML > $1/index.html

        #uncomment the statement below if you have multiple SDK locations
        #echo ""
	    echo "Created new ticket in directory $1."
        echo "Linked to SDK location at $SDK."
        exit 0
    fi
fi
