#!/usr/bin/sh

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

while getopts "vh" OPTION
do
    case $OPTION in
        h)
            echo "$0 $PROG_NAME <mbox path> [options]"
            echo "  -v | Be verbose"
            exit 1
            ;;
        v)
            VERBOSE=1
            ;;
    esac

    sleep 1
done

output() {
    verbose && echo -e "[$0]: $1"
}

tmp_branch="apply-$$"

output "Checking out $tmp_branch"
git checkout -b $tmp_branch

for file in $(find $box -type f | sort)
do
    output "Applying $file"
    git am < $file

    output "Removing $file"
    rm $file
done

output "Done."
