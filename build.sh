#!/bin/bash

name=${OFF_BIN:-offenbach}
srcdir=src
builddir=bin

_msg(){
    local fmt=$1"\n"
    shift 1
    set -- "${fmt}" $@
    printf "$@"
}

_err(){
    _msg "$@"
    exit 1
}

version=$1

# Check builder was invoked with a version number
if [ -z "${version}" ]
then
    _err "Missing version argument."
fi

# Check given version is conform to semver format
if ! echo ${version} | grep '[0-9]\+\.[0-9]\+\.[0-9]\+' >/dev/null
then
    _err "Bad version format. Should be of the form X.Y.Z (eg: 1.2.18). Aborting."
fi

oldvers=`git tag -l | tail -1`

# Check given version is greater than the last one
if [ "${version//./}" -le "${oldvers//./}" ]
then
    _err "Bad version number: \033[01;30m%s\033[00m <= \033[01;30m%s\033[00m. Aborting." ${version} ${oldvers}
fi

# Build distributable script
sed "s/@@version@@/${version}/" ${srcdir}/${name} > ${builddir}/${name}

# Display success message
_msg "Successfully built \033[01;34m%s\033[00m version \033[01m%s\033[00m" ${name} ${version}
