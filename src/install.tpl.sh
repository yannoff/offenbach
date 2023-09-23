#!/bin/bash
#
# Offenbach online installer script
#
# This file is part of the Offenbach Project
#
# (c) 2019-2023 Yannoff (https://github.com/yannoff)
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

# Defaults: use env variables if defined, fallback values otherwise
[ -z "${OFFENBACH_INSTALL_DIR}" ] && install_dir=${PWD} ||  install_dir=${OFFENBACH_INSTALL_DIR}
exe_version=${OFFENBACH_VERSION:-latest}
executable=${OFFENBACH_FILENAME:-offenbach}

#
# Download the given executable to the global $install_dir directory
#
# Usage: _download <project> [<version>] [<exec>] [<asset>]
#
# @param $project The github repository name
# @param $version The version to download (defaults to "latest")
# @param $exe     The final executable filepath (defaults to $asset)
# @param $asset   Name of the release asset to download (defaults to $project)
#
# @global $install_dir Directory where the executable will reside
#
_download(){
    local project=${1} version=${2:-latest} exe=${3} asset=${4} uri
    [ -z "${asset}" ] && asset=${project}
    [ -z "${exe}" ] && exe=${asset}
    _debug "Downloading %s version %s ..." "${asset}" "${version}"
    [ "${version}" == "latest" ] && uri=latest/download || uri=download/${version}
    _exec curl -Lo ${exe} https://github.com/yannoff/${project}/releases/${uri}/${asset}
    _debug "Making downloaded file %s executable..." "${exe}"
    _exec chmod -v +x ${exe}
}

#
# Print the given command, execute it, print result and return its execution status
#
# Usage: _exec <command> [<options>] [<args>]
#
# @param $command    The command to execute
# @param $option1..N Optional command options
# @param $args1..N   Optional command arguments
#
_exec(){
    local output status
    printf "> %s\n" "${*}"
    output="$("${@}" 2>&1)"
    status=$?
    printf "\033[01;30m%s\033[00m\n" "${output}"
    return ${status}
}

#
# Print the given formatted message to standard output
#
# Usage: _debug <format> [<var1>...<var2>]
#
# @param $format  The printf formatting text
# @param $var1..N The placed values
#
_debug(){
    local fmt
    # Make the text bold
    fmt="\033[01m=> ${1}\033[00m"
    shift 1
    # Highlight values in blue
    args=()
    for arg; do args+=("[01;34m${arg}[01;37m"); done
    set -- "${fmt}\n" "${args[@]}"
    printf "${@}" >&2
}

#
# Exit with an error message
#
# Usage: _error <message> [<code>]
#
# @param $message The error message to print
# @param $code    Optional exit status code (defaults to 1)
#
_error(){
    local msg=${1} code=${2}
    printf "Error: %s.\nExiting.\n" "${msg}"
    exit ${code:-1}
}

#
# Print a warning message to the standard error
#
# Usage: _warn <format> [<var1>...<var2>]
#
# @param $format  The printf formatting text
# @param $var1..N The placed values
#
_warn(){
    local fmt=${1}
    shift 1
    set -- "Warning: ${fmt}.\n" "$@"
    printf "$@" >&2
}

#
# Prints the version of the given executable
#
# Usage: _get_version <executable>
#
# @param $executable The executable (short) name
#
_get_version(){
    local version
    case ${1} in
        curl)
            version=$(curl --version 2>/dev/null | awk '(NR==1) { print $2; }')
            ;;
        yamltools)
            version=$(yamltools --version --raw 2>/dev/null | tr -d "\n\t\r")
            ;;
        *)
            version=$(${1} --version | head -1 | tr -d "[a-z ]")
            ;;
    esac
    echo ${version}
}

#
# Give the version a canonical form suitable for comparison
# Examples:
#       _canonize 1.4.27 => 1004027
#       _canonize 1.6.1  => 1006001
#
# Usage: _canonize <version>
#
# @param $version The semver version number (X.Y.Z)
#
_canonize(){
    local version=${1} canonical=0 iter=1
    for v in $(echo "${version}" | awk -F "." '{ for(i=1;i<=NF;i++) print $i; }' | tac)
    do
        let canonical=canonical+v*iter
        let iter*=1000
    done

    echo ${canonical}
}

#
# Get the install dir of a given dependency
# If not installed yet, fallback to $HOME/bin if it exists, /usr/bin otherwise
#
# Usage: _get_install_dir <dependency>
#
# @param $dependency The dependency basename
#
_get_install_dir(){
    local bindir dependency=${1}
    deppath=$(which ${dependency})
    if [ -z "${deppath}" ]
    then
         [ -d "$HOME/bin" ] && bindir=$HOME/bin || bindir=/usr/bin
    else
        bindir=$(dirname ${deppath})
    fi
    echo "${bindir}"
}

#
# Check whether the given executable is installed, optionally checking for the given minimum version requirement
#
# Usage: _check <executable> [<min-version>]
#
# @param $executable  The executable (short) name
# @param $min-version Optional minimal required version
#
_check(){
    local msg version actual minimum
    msg="Checking whether %s is installed..."
    version=$(_get_version ${1})
    
    if [ -n "${version}" ]
    then
        if [ -n "${2}" ]
        then
            actual=$(_canonize "${version}")
            minimum=$(_canonize "${2}")
            if [ "${actual}" -lt "${minimum}" ]
            then
                _debug "${msg} - version requirement unmet (%s < %s)" "${1}" "${version}" "${2}"
                return 127
            fi
        fi
        
        _debug "${msg} yes - version %s" "${1}" "${version}"
        return 0
    fi

    _debug "${msg} no" "${1}"
    return 127
}

#
# Prints help message to standard output
#
_usage() {
    cat >&2 <<EOH
[01mUsage:[00m
    $0 [--install-dir=<dir>] [--filename=<name>] [--version=<version>]
[01mOptions:[00m
    --install-dir The script installation dir (defaults to: [01m\$PWD[00m)
    --filename    The name of the executable (defaults to: [01moffenbach[00m)
    --version     The version to install (defaults to: [01mlatest[00m)
EOH
}

# Parse command-line arguments, and set variables accordingly
while [ $# -gt 0 ]
do
    case $1 in
        # Support passing options in the --option=value fashion
        --*=*)
            arg=$1
            option=${arg%%=*}
            value=${arg##*=}
            shift 1
            set -- ${option} ${value} $@
            ;;
        --help|-h|--usage)
            _usage
            exit 0
            ;;
        --install-dir)
            install_dir=${2%/}
            shift 2
            ;;
         --filename)
            executable=$2;
            shift 2
            ;;
         --version)
            exe_version=$2;
            shift 2
            ;;
        --*)
            _warn 'Unrecognized option "%s", ignoring' $1
            shift
            ;;
    esac
done

# Change directory for the installation dir
_debug "Changing current directory to: %s" ${install_dir}
cd ${install_dir}

# If curl is not present, exit with an error message
if ! _check curl
then
    _error "You need CURL to run this script." 127
fi

# If yamltools binary is missing, download it
yamltools_version=@@yamltools_version@@
if ! _check yamltools ${yamltools_version}
then
    bindir=$(_get_install_dir yamltools)
    _download yamltools ${yamltools_version} ${bindir}/yamltools
fi

# Download the offenbach script
_download offenbach ${exe_version} ${executable}

# Smoke test
_debug "Installed offenbach as: %s." "${install_dir}/${executable}"
_debug "Running smoke tests..."
# Test with full path
_debug "Pass 1/2: calling absolute path"
_exec $(realpath ${PWD})/${executable} --version
# Test with shortname (ensure executable is in PATH)
_debug "Pass 2/2: calling shortname"
_exec ${executable} --version
# Caveat on the installed executable not being in one of the PATH directories
[ "$?" -eq "127" ] && _warn 'it seems that "%s" is not in any of the known executable paths' "${executable}"

echo -ne "\033[01m"
cat <<EOM
************************************************************************************************
                          Offenbach installation complete !

          Be sure the "${install_dir}" directory is in your PATH environment variable.
************************************************************************************************
EOM
echo -ne "\033[00m"
