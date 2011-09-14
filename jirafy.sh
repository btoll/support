#!/bin/bash

EXPECTED_ARGS=1
# get preset environment variable or set a default location
DEFAULT_TICKETS_DIR=${EXT_TICKETS_DIR-"/usr/local/www/extjs/tickets/"}
DEBUG_SCRIPT="ext-all-debug-w-comments.js"

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: $0 <JIRA_bug_ticket_number>"
    exit 1
else
    if [ -f $1.html ]; then
        echo "Warning: File already exists, exiting..."
        exit 1
    else
        read -p "Location of SDK: [$DEFAULT_TICKETS_DIR] " SDK
        TICKETS_DIR=${TICKETS_DIR:-$DEFAULT_TICKETS_DIR}

        read -p "Enter relative path to file: " FILE

        if [ ! -f ${TICKETS_DIR}$FILE ]; then
            echo ""
            echo "Error: File doesn't exist, check your path. Exiting..."
            exit 1
        fi

        # the following will copy JavaScript code and insert it into the new document,
        # replacing the line "//your test case goes here"

        # if the file is a JavaScript script then copy the contents of the entire script
        if [[ $FILE =~ ".js" ]]; then
            sed "/your test case goes here/ {
                r ${TICKETS_DIR}$FILE
                d
            }" template.html > $1.html

        # if the file is an HTML/PHP/other document then get all the text between the <script> tags
        # NOTE that this doesn't match sourced script tags, i.e., <script src="my_js.js"></script>
        # the intent is to only get inline JavaScript
        # TODO: currently it only copies the contents of the first <script> tag it meets
        else
            sed -e '1,/<script>/d' -e '/<\/script>/,$d' < ${TICKETS_DIR}$FILE > tmp
            sed '/your test case goes here/ {
                r tmp
                d
            }' template.html > $1.html
            rm tmp
        fi

        echo ""
	echo "Created new test case $1.html"
        exit 0
    fi
fi
