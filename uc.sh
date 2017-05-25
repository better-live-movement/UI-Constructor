#!/bin/bash
# ------------------------------------------------------------------
# [Melchior Kannengießer] UI Constructor
#
# This script initialize a UI project
#
# --- change log ---------------------------------------------------
# [0.0.1] - 2017-05-25
# Added
# - initial Ideas
# ------------------------------------------------------------------
VERSION=0.0.1
SUBJECT=some-unique-id
USAGE="Usage: command -ihv args"
EXEMPLE="e.g. `basename $0` -i some args"
HELP="
NAME
    `basename $0`
SYNOPSIS
    `basename $0` [-ihv] some args
DESCRIPTION
    this script does something
    -i
        show given arguments
    -h
        show this help text
    -v
        show the script-version
"
# --- Options processing -------------------------------------------
if [ $# == 0 ] ; then
    echo $USAGE >&2
    echo $EXAMPLE >&2
    exit 1;
fi
while getopts ":i:vh" optname
  do
    case "$optname" in
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "i")
        echo "-i argument: $OPTARG"
        ;;
      "h")
        echo "$HELP"
        exit 0;
        ;;
      "?")
        echo "Unknown option $OPTARG" >&2
        exit 1;
        ;;
      ":")
        echo "No argument value for option $OPTARG" >&2
        exit 1;
        ;;
      *)
        echo "Unknown error while processing options" >&2
        exit 1;
        ;;
    esac
  done
shift $(($OPTIND - 1))
param1=$1
param2=$2
# --- Locks -------------------------------------------------------
LOCK_FILE=/tmp/$SUBJECT.lock
if [ -f "$LOCK_FILE" ]; then
   echo "Script is already running"
   exit
fi
trap "rm -f $LOCK_FILE" EXIT
touch $LOCK_FILE
# --- Body --------------------------------------------------------
#  SCRIPT LOGIC GOES HERE
echo $param1
echo $param2
mkdir $param1 && cd $param1
npm init -y
npm install --save-dev webpack
npm install --save lodash
mkdir app && cd app
touch index.js
#-create-file:-index.js---------------------------------------------
echo "import _ from 'lodash';" >> index.js
echo " " >> index.js
echo "function component () {" >> index.js
echo "  var element = document.createElement('div');" >> index.js
echo " " >> index.js
echo "  /* lodash is required for the next line to work */" >> index.js
echo "  element.innerHTML = _.join(['Hello','webpack'], ' ');" >> index.js
echo " " >> index.js
echo "  return element;" >> index.js
echo "}" >> index.js
echo " " >> index.js
echo "document.body.appendChild(component());" >> index.js
# -----------------------------------------------------------------
cd ..
touch index.html
#-create-file:-index.html------------------------------------------
echo "<html>" >> index.html
echo "  <head>" >> index.html
echo "    <title>$param1</title>" >> index.html
echo "  </head>" >> index.html
echo "  <body>" >> index.html
echo "    <script src="dist/bundle.js"></script>" >> index.html
echo "  </body>" >> index.html
echo "</html>" >> index.html
# -----------------------------------------------------------------
./node_modules/.bin/webpack app/index.js dist/bundle.js
xdg-open ./index.html
# -----------------------------------------------------------------
exit 0
