#******************************************************************************
#
#   Shell Profiles
#
#******************************************************************************

#
# Load profile
#
my_path="$(cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")"; pwd)"
dist_name="$(${my_path}/../tools/detect_distribution.sh)"
if [ -n "${dist_name}" -a -f "${my_path}/.profile.${dist_name}" ]; then
    . "${my_path}/.profile.${dist_name}"
fi

unset my_path
unset dist_name
