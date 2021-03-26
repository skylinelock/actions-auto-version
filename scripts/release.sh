#!/bin/bash

echo "Running release.sh"

git fetch --prune --unshallow --tags
pre_tag=`git tag -l | tail -n 1 | awk '{print $1}'`
pre_version=${pre_tag#"v"}

prefix=`echo $PR_TITLE | awk '{print $1}'`

command=`echo "$prefix" | awk '{print tolower($0)}'`

version="v1.0.0"

if [ -z "$pre_tag" ]; then
    echo "::set-output name=version::$version"
    echo "New tag v1.0.0"
    exit 0
fi

fix=`echo $pre_version | awk -F '.' '{print $3}'`
minor=`echo $pre_version | awk -F '.' '{print $2}'`
major=`echo $pre_version | awk -F '.' '{print $1}'`

echo $PR_TITLE
echo $prefix
echo $command

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
echo "New tag $version"