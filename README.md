### Environment variables
Define some environment variables that the bash scripts will use.
For example (note there are no trailing forward slashes for the directory locations):

    export EXT_SDK=../../..
    export EXT_BUILDS=../../builds
    export TICKETS_DIR=../../tickets

### Setup aliases
For example:

    alias mvc="/usr/local/www/support/mvc.sh"
    alias jirafy="/usr/local/www/support/jirafy.sh"
    alias create_ticket="/usr/local/www/support/create_ticket.sh"

----------------------------------------------------------------------------------------

### MVC bash script
Example usage:
    `mvc testmvc 4.0.6`

    mvc dir_name ext_version

It will ask for the location of the SDK (taken from environment variable or hard-coded default in the bash script).  Hit enter to select the preset path.  That's it.

This does the following:

- creates the MVC directory structure.
- creates a soft link to the Ext version and names it `ext`.
- creates an `index.html` document and references `ext-debug.js`, `ext-all.css` and `app.js`.
- creates a basic `app.js` script.

At this point, point your browser to `http://localhost/path_to_mvc_dir/` and a skeleton MVC app will load.

### Jirafy bash script
Example usage:
    `jirafy 4651`

    jirafy JIRA_bug_ticket_number

Run the script in the `extjs/test/issues` directory.

It will ask for:

- the location of the SDK (taken from environment variable or hard-coded default in the bash script).  Hit enter to select the preset path.
- the location of the file for which it will extract the JavaScript code.

This does the following:

- if the specified file is an HTML document, uses `sed` to read the file and copy the JavaScript code between any `<script>` tags it encounters in the document.  This then replaces the line '//your test case goes here' in `template.html` and creates your new file (in this example, `4651.html`) by redirecting STDOUT.
- if the specified file is a JavaScript script, uses `sed` to read the entire file which then replaces the line '//your test case goes here' in `template.html` and creates your new file (in this example, `4651.html`) by redirecting STDOUT.
