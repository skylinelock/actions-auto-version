#!/bin/bash

echo "Running release.sh"

pre_version=`git tag -l | tail -n 1 | awk '{print $1}'`

prefix=`echo $PR_TITLE | awk '{print $1}'`

command=`$(echo "$prefix" |  tr '[:upper:]' '[:lower:]' )`

if [ -z "$pre_version" ]; then
    echo "::set-output name=version::$version"
    echo "Applied 1.0.0"
    exit 1
fi

fix=`echo $pre_version | awk -F '.' '{print $3}'`
minor=`echo $pre_version | awk -F '.' '{print $2}'`
major=`echo $pre_version | awk -F '.' '{print $1}'`

case "$command" in
    "fix" ) fix=`expr $fix + 1` ;;
    "minor" ) 
        fix=0
        minor=`expr $minor + 1`
        ;;
    "major" ) 
        fix=0
        minor=0
        major=`expr $major + 1`
        ;;
    * ) fix=`expr $fix + 1` ;;
esac

version="v$major.$minor.$fix"
echo "::set-output name=version::$version"