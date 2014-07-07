#!/bin/sh

# apply patches from a mailbox onto the current branch (with creating a new one)

PROG_NAME=apply-mbox

box=$1
shift

if [ "$box" == "" ]
then
    echo "No box given"
    exit 1
fi

VERBOSE=0
BUILD=0
BUILD_ARG=

while getopts "b:vh" OPTION
do
    case $OPTION in
        h)
            echo "$0 $PROG_NAME <mbox path> [options]"
            echo "  -b <args>   | Call make afterwards, pass <args> to make"
            echo "  -v          | Be verbose"
            exit 1
            ;;
        v)
            VERBOSE=1
            ;;
        b)
            BUILD=1
            BUILD_ARG=$OPTARG
            ;;

    esac

    sleep 1
done

verbose() {
    [[ $VERBOSE -eq 1 ]]
}

output() {
    verbose && echo -e "[$0]: $1"
}

tmp_branch="apply-$$"

output "Checking out $tmp_branch"
git checkout -b $tmp_branch

for file in "$(find $box -type f | sort)"
do
    output "Applying $file"
    git am < "$file" || exit 1

    output "Removing $file"
    rm "$file"
done

output "Done."

if [ $BUILD -eq 1 ]
then
    output "Trying to build using 'make $BUILD_ARG'"
    make $BUILD_ARG
fi
