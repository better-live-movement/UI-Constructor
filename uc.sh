#!/bin/bash
# ------------------------------------------------------------------
# [Melchior Kannengießer] UI Constructor
#
# This script initialize a UI project
# ------------------------------------------------------------------
VERSION=0.0.1
SUBJECT=some-unique-id
USAGE="Usage: command -ihv args"
EXEMPLE="e.g. `basename $0` -i new ui"
HELP="
NAME
    `basename $0`
SYNOPSIS
    `basename $0` [-ihv] <command>
DESCRIPTION
    this script initialize a UI project

COMMANDS
    new <app name>
        initialize a new UI project
    set <key> <value>
        TODO will set set the default values for the options someday

OPTIONS
    -i
        show given arguments
    -h
        show this help text
    -v
        show the script-version
    -r
        install redux
    -l
        long init
"
# --- Options processing -------------------------------------------
redux=false
longInit=false

if [ $# == 0 ] ; then
    echo $USAGE >&2
    echo $EXAMPLE >&2
    exit 1;
fi
while getopts ":i:vhrlmgw" optname
  do
    case "$optname" in
      "i")
        echo "-i argument: $OPTARG"
        ;;
      "h")
        echo "$HELP"
        exit 0;
        ;;
      "v")
        echo "Version $VERSION"
        exit 0;
        ;;
      "r")
        echo "Install redux" #soon tm
        redux=true
        ;;
      "l")
          echo "long init"
        longInit=true
        ;;

      "w")
        echo "webpack" #soon tm
        wp=true
        ;;

      "m")
        echo "material ui" #soon tm
        mu=true
        ;;

      "g")
        echo "git" #soon tm
        git=true
        ;;
      "p")
        echo "PhoneGap" #soon tm
        PhoneGap=true
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

# --- Commands processing -----------------------------------------
if [ "$param1" == "set" ]
then
  echo "set config is not implemented yet"
  exit 0;
elif [ "$param1" == "new" ]
then
  AppName=$param2
else
  echo "unknown command" >&2
  echo $USAGE >&2
  echo $EXAMPLE >&2
  exit 1;
fi

# --- Initialize npm project --------------------------------------
echo "create $AppName..."
mkdir $AppName && cd $AppName
if [ "$longInit" == false ]; then
  touch package.json
  echo '{' >> package.json
  echo '  "name": "'$AppName'",' >> package.json
  echo '  "version": "0.1.0",' >> package.json
  echo '  "description": "",' >> package.json
  echo '  "scripts": {' >> package.json
  echo '    "start": "npm run build",' >> package.json
  echo '    "build": "webpack -d && cp src/index.html dist/index.html && webpack-dev-server --content-base src/ --inline --hot --port 8080",' >> package.json
  echo '    "build:prod": "wbpack -p && cp src/index.html dist/index.html"' >> package.json
  echo '  },' >> package.json
  echo '  "keywords": [],' >> package.json
  echo '  "author": "",' >> package.json
  echo '  "license": "ISC"' >> package.json
  echo '}' >> package.json
else
  npm init
fi
# --- Install prod dependencies -----------------------------------
# if [ "$foo" == true ]; then
#   npm install foo --save
# fi
npm install react react-dom --save

# --- Install dev dependencies ------------------------------------
# if [ "$foo" == true ]; then
#   npm install foo --save
# fi
npm install webpack --save-dev
npm install webpack-dev-server --save-dev
npm install babel-core --save-dev
npm install babel-loader --save-dev
npm install babel-preset-es2016 --save-dev
npm install babel-preset-stage-2 --save-dev
npm install babel-preset-react --save-dev

#-add-scripts-to-package.js----------------------------------------
#sed -i '/"scripts":{/r ~/.uc/scrips.conf' package.json

#-create-file:-webpack.config.js-----------------------------------
touch webpack.config.js
echo 'var webpack = require("webpack");' >> webpack.config.js
echo 'var path = require("path");' >> webpack.config.js
echo ' ' >> webpack.config.js
echo 'var DIST_DIR = path.resolve(__dirname, "dist");' >> webpack.config.js
echo 'var SRC_DIR = path.resolve(__dirname, "src");' >> webpack.config.js
echo ' ' >> webpack.config.js
echo 'var config = {' >> webpack.config.js
echo '  entry: SRC_DIR + "/app/index.js",' >> webpack.config.js
echo '  output: {' >> webpack.config.js
echo '    path: DIST_DIR + "/app",' >> webpack.config.js
echo '    filename: "bundle.js",' >> webpack.config.js
echo '    publicPath: "/app/"' >> webpack.config.js
echo '  },' >> webpack.config.js
echo '  module: {' >> webpack.config.js
echo '    rules: [' >> webpack.config.js
echo '      {' >> webpack.config.js
echo '        test: /\.js?/,' >> webpack.config.js
echo '        include: SRC_DIR,' >> webpack.config.js
echo '        loader: "babel-loader",' >> webpack.config.js
echo '        query: {' >> webpack.config.js
echo '          presets: ["react", "es2016", "stage-2"]' >> webpack.config.js
echo '        }' >> webpack.config.js
echo '      }' >> webpack.config.js
echo '    ]' >> webpack.config.js
echo '  }' >> webpack.config.js
echo '};' >> webpack.config.js
echo ' ' >> webpack.config.js
echo 'module.exports = config;' >> webpack.config.js

#-create-file:-index.html------------------------------------------
mkdir src && cd src
touch index.html
echo '<html>' >> index.html
echo '  <head>' >> index.html
echo '    <meta charset="UTF-8">' >> index.html
echo '    <meta name="viewport"' >> index.html
echo '          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">' >> index.html
echo '    <title>'$AppName'</title>' >> index.html
echo '  </head>' >> index.html
echo '  <body>' >> index.html
echo '    <div id="app"></div>' >> index.html
echo '    <script src="/app/bundle.js"></script>' >> index.html
echo '  </body>' >> index.html
echo '</html>' >> index.html

#-create-file:-index.js--------------------------------------------
mkdir app && cd app
touch index.js
echo 'import React from '"'"'react'"'"';' >> index.js
echo 'import ReactDom from '"'"'react-dom'"'"';' >> index.js
echo ' ' >> index.js
echo 'class Layout extends React.Component {' >> index.js
echo '  render(){' >> index.js
echo '    return(' >> index.js
echo '      <div>' >> index.js
echo '        <h1>'$AppName'</h1>' >> index.js
echo '        <p>under construction</p>' >> index.js
echo '      </div>' >> index.js
echo '    );' >> index.js
echo '  }' >> index.js
echo '}' >> index.js
echo ' ' >> index.js
echo 'const app = document.getElementById('"'"'app'"'"');' >> index.js
echo ' ' >> index.js
echo 'ReactDom.render(<Layout/>, app);' >> index.js
echo 'console.log("It works realy! ;-)");' >> index.js

#-build-and-run-dev-server-----------------------------------------
cd ../..
npm start
# -----------------------------------------------------------------
exit 0
