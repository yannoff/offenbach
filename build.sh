#!/bin/bash
#
# This file is part of the Offenbach Project
#
# (c) 2019-2024 Yannoff (https://github.com/yannoff)
#
# @project  Offenbach
# @author   Yannoff (https://github.com/yannoff)
# @link     https://github.com/yannoff/offenbach
# @license  http://opensource.org/licenses/MIT
#
# For the full copyright and license information,
# please view the LICENSE file bundled with this
# software sources.
#
# For internal use only
#

name=${OFF_BIN:-offenbach}
srcdir=src
builddir=bin
depfile=dependencies.yaml

_msg(){
    local fmt=$1"\n"
    shift 1
    set -- "${fmt}" "$@"
    printf "$@"
}

_err(){
    _msg "$@"
    exit 1
}

version=$1
build_date=`date -Iseconds`

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
version_num=${version//./}
version_num=${version_num%%-*}
oldvers_num=${oldvers//./}
oldvers_num=${oldvers_num%%-*}
if [ "${version_num}" -le "${oldvers_num}" ]
then
    _err "Bad version number: \033[01;30m%s\033[00m <= \033[01;30m%s\033[00m. Aborting." ${version} ${oldvers}
fi

# Build distributable script
cp ${srcdir}/${name} ${builddir}/${name}
sed -i "s/@@version@@/${version}/" ${builddir}/${name}
sed -i "s/@@date@@/${build_date}/" ${builddir}/${name}

# Build online installer script
sed "s/@@yamltools_version@@/$(awk -F ': ' '($1 == "yamltools") { print $2; }' ${depfile} | tr -d ' ')/" ${srcdir}/install.tpl.sh > install.sh

# Build github action script
action=actions/install/action.yaml
cp ${srcdir}/action.tpl.yaml ${action}
sed -i "s/@@offenbach_version@@/${version}/" ${action}
sed -i "s/@@yamltools_version@@/$(awk -F ': ' '($1 == "yamltools") { print $2; }' ${depfile} | tr -d ' ')/" ${action}

# Update README's release badge version number
sed -i "s#https://img.shields.io/badge/Release-\([0-9]\+.[0-9]\+.[0-9]\+\)-blue#https://img.shields.io/badge/Release-${version}-blue#" README.md

# Display success message & display version command output
test_command="${builddir}/${name} --version"
_msg "Successfully built \033[01;34m%s\033[00m version \033[01m%s\033[00m" ${name} ${version}
_msg "Running \033[01;30m%s\033[00m command:" "${test_command}"
${test_command}
