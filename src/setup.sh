#!/bin/sh

# setup the working environment.

VERBOSE=0

while getopts "v" OPTIONS
do
    case $OPTIONS in
        v)
            VERBOSE=1
            ;;
    esac
done

verbose() {
    [[ $VERBOSE -eq 1 ]]
}

output() {
    verbose && echo "[$0]: $1"
}

setup_apply_mbox() {
    mkdir /tmp/kernel_apply
    mkdir /tmp/kernel_apply/cur
    mkdir /tmp/kernel_apply/new
    mkdir /tmp/kernel_apply/tmp
}

setup_apply_mbox
