#!/bin/bash +x

#
# Constants
#
readonly SCRIPT_NAME=$(basename $0)


#
# Varibles for Args
#
OPT_OUTPUT_FILE_PATH=
OPT_NO_COPY=

#
# Prepare temp dir
#
unset TMP_DIR
on_exit() {
    [[ -n "${TMP_DIR}" ]] && rm -rf "${TMP_DIR}";
}
trap on_exit EXIT
trap 'trap - EXIT; on_exit; exit -1' INT PIPE TERM
readonly TMP_DIR=$(mktemp -d "/tmp/${SCRIPT_NAME}.tmp.XXXXXX")


#
# Usage
#
usage () {
    cat << __EOS__
Usage:
    ${SCRIPT_NAME} [-h] [-n] {[-o] output_file_path} video_path1 video_path2...

Description:
    concat videos

OUTPUT_FILE_PATH:
    output file path.

Options:
    -h  show usage.
    -n  no copy.
    -o  output file path.

__EOS__
}

parse_args() {
    while getopts hno: flag; do
        case "${flag}" in
            h )
                usage
                exit 0
                ;;

            n )
                OPT_NO_COPY='true'
                ;;

            o )
                OPT_OUTPUT_FILE_PATH=${OPTARG}
                ;;
            * )
                usage
                exit 0
                ;;
        esac
    done
}

err() {
    echo "Error: $@" 1>&2
    usage
    exit 1
}


#
# main method
#
main() {
    local concat_index_file=${TMP_DIR}/concat.index
    local output_file_path=
    local opt_copy='-c copy'

    parse_args $@
    shift `expr $OPTIND - 1`

    if [ $# -le 1 ]; then
        err "input files must be speficied two or more."
    fi

    # Setup input files index.
   for i in ${@:1:$#}; do
        if [ ! -f ${i} ]; then
            err "input file not found: ${i}"
        fi

        path=$(readlink -f ${i})
        echo "file '${path}'" >> ${concat_index_file}
    done

    # Setup output file path.
    if [ -z "${OPT_OUTPUT_FILE_PATH}" ]; then
        output_file_path="./${1%.*}_concat.${1##*.}"
    else
        output_file_path=${OPT_OUTPUT_FILE_PATH}
    fi

    # concat videos
    if [ -n "${OPT_NO_COPY}" ]; then
        opt_copy=''
    fi
    ffmpeg -f concat -safe 0 -i ${concat_index_file} ${opt_copy} ${output_file_path}

    exit 0
}


#
# Entry Point
#
main $@
exit 0

