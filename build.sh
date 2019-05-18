#!/bin/bash

name=${OFF_BIN:-offenbach}
srcdir=src
builddir=bin

version=$1
if [ -z "${version}" ]
then
    echo "Missing version argument."
    exit 1
fi

sed "s/@@version@@/${version}/" ${srcdir}/${name} > ${builddir}/${name}
