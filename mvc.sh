#!/bin/bash

EXPECTED_ARGS=2
# get preset environment variable or set a default location
DEFAULT_SDK_LOCATION=${EXT_SDK:-"/usr/local/www/extjs/builds"}
# convert dirname to UPPERCASE to use as our app global var
NAME=`echo $1 | tr "[:lower:]" "[:upper:]"`
HTML="<html>\n<head>\n<title>$1 MVC</title>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"ext/resources/css/ext-all.css\" />\n<script type=\"text/javascript\" src=\"ext/ext-debug.js\"></script>\n<script type=\"text/javascript\" src=\"app.js\"></script>\n</head>\n\n<body>\n</body>\n</html>"
JS="Ext.application({\n\tname: \"$NAME\",\n\tappFolder: \"app\",\n\t//autoCreateViewport: true,\n\n\tcontrollers: [],\n\tmodels: [],\n\tstores: [],\n\n\tlaunch: function () {\n\t\tExt.create(\"Ext.container.Viewport\", {\n\t\t\tlayout: \"fit\",\n\t\t\titems: [{\n\t\t\t\txtype: \"panel\",\n\t\t\t\ttitle: \"$1\",\n\t\t\t\thtml: \"Default text\"\n\t\t\t}]\n\t\t});\n\t}\n});"

if [ $# -ne $EXPECTED_ARGS ]; then
    echo "Usage: $0 <dir_name> <ext_version>"
    exit 1
else
    if [ -d $1 ]; then
        echo "Warning: Directory already exists, exiting..."
        exit 1
    else
        #HTML="<html>\n<head>\n<title>$1 MVC</title>\n<link rel=\"stylesheet\" type=\"text/css\" href=\"$SDK/$2/resources/css/ext-all.css\" />\n<script type=\"text/javascript\" src=\"$SDK/$2/ext-debug.js\"></script>\n<script type=\"text/javascript\" src=\"app.js\"></script>\n</head>\n\n<body>\n</body>\n</html>"

        # create the dirs and the Viewport.js script
	mkdir -m 0755 -p $1/data $1/app/controller $1/app/model $1/app/store $1/app/view
	touch $1/app/view/Viewport.js

        # echo HTML honoring the new lines (-e flag)
        echo -e $HTML > $1/index.html

        # echo honoring new lines, change new lines to 4 spaces and remove tmp file
        echo -e $JS > tmp && expand -t 4 tmp > $1/app.js && rm tmp

        # link to the SDK
        read -p "Location of SDK: [$DEFAULT_SDK_LOCATION] " SDK
        SDK=${SDK:-$DEFAULT_SDK_LOCATION}

	ln -s $SDK/$2 $1/ext

        echo ""
	echo "MVC structure created in directory $1."
        echo "Linked to SDK location at $SDK."
        exit 0
    fi
fi
