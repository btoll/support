#!/bin/bash

VER=$2
EXPECTED_ARGS=2
# Note no trailing forward slashes for the dir locations.
DEFAULT_SDK_LOCATION="../../../SDK"
DEFAULT_BUILDS_LOCATION="../../builds"
ONREADY="Ext.onReady(function () {\n});"

# First establish some conditions that must be met or exit early.
if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: $0 <ticket_dir_name> <ext_version>"
    exit 1
else
    if [ -d $1 ]; then
        echo "Warning: Directory already exists, exiting..."
        exit 1
    fi
fi

# If the env vars haven't been set for EXT_SDK and EXT_BUILDS, then prompt for their locations.
if [ "SDK" = $VER ]; then
    VER="extjs"
    DEBUG_SCRIPT="ext.js"
    # Link to the SDK.
    if [ -z $EXT_SDK ]; then
        # Get preset environment variable or set a default location (logical OR ----> ":-").
        read -p "Location of SDK: [$DEFAULT_SDK_LOCATION] " SDK
        # If user accepted default location then SDK var will be unset.
        SDK=${SDK:-$DEFAULT_SDK_LOCATION}
    else
        SDK=$EXT_SDK
    fi
else
    # Extract the first character of the Ext version.
    MACRO_VER=${VER:0:1}
    DEBUG_SCRIPT="ext-debug.js"

    # Link to the SDK.
    if [ -z $EXT_BUILDS ]; then
        # Get preset environment variable or set a default location (logical OR ----> ":-").
        read -p "Location of build: [$DEFAULT_BUILDS_LOCATION] " SDK
        # If user accepted default location then SDK var will be unset.
        SDK=${SDK:-$DEFAULT_BUILDS_LOCATION}
    else
        SDK=$EXT_BUILDS
    fi

    # If the version number is 2.x or 3.x then change the debug script.
    if [ $MACRO_VER -lt 4 ]; then
        DEBUG_SCRIPT="ext-all-debug.js"
        ADAPTER="<script type=\"text/javascript\" src=\"$SDK/$VER/adapter/ext/ext-base.js\"></script>\n"
    fi
fi

# Create the new ticket dir.
mkdir -m 0755 -p $1

HTML="<html>\n<head>\n<title>$1</title>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"$SDK/$VER/resources/css/ext-all.css\" />\n$ADAPTER<script type=\"text/javascript\" src=\"$SDK/$VER/$DEBUG_SCRIPT\"></script>\n<script type=\"text/javascript\">\n$ONREADY\n</script>\n</head>\n\n<body>\n</body>\n</html>"

# Echo HTML honoring the new lines (-e flag).
echo -e $HTML > $1/index.html

# Uncomment the statement below if you have multiple SDK locations.
#echo ""
echo "Created new ticket in directory $1."
echo "Linked to SDK location at $SDK."
exit 0
