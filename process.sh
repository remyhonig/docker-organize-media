#!/bin/bash
cd /src
echo "check for new files"

# 2014:09:19 17:34:50
function extract_datetime_image
{
    # Date/Time    : 2014:09:19 17:34:50
    echo $(jhead $1 | grep "Date/Time" | awk -F:\  '{print $2}')
}

# 2014:09:19
function extract_datetime_movie
{
    # Encoded date                             : UTC 2014-09-19 16:25:46
    echo $(mediainfo $1 | grep "Encoded date" | head -n 1 | awk -F\  '{print $5}')
}

# 2014/12/10
function datetime_to_directory
{
    local dt=$1
    local y=${dt:0:4}
    local m=${dt:5:2}
    local d=${dt:8:2}
    echo "$y/$m/$d"
}

function process_image
{
    srcpath=$(readlink -f "$1")
    dt=$(extract_datetime_image $srcpath)
    dstdir="/dst/$(datetime_to_directory $dt)"
    dstpath="$dstdir/$(basename $srcpath)"
    echo "mkdir -p $dstdir && mv $srcpath $dstpath"
}

function process_movie
{
    srcpath=$(readlink -f "$1")
    dt=$(extract_datetime_movie $srcpath)
    dstdir="/dst/$(datetime_to_directory $dt)"
    dstpath="$dstdir/$(basename $srcpath)"
    echo "mkdir -p $dstdir && mv $srcpath $dstpath"
}

find . -type f -iname '*.jpg' |
    while IFS=$'\n' read -r FILE; do
        cmd=$(process_image $FILE)
        echo $cmd
        eval $cmd || echo "error processing: $FILE"
    done

find . -type f \( -iname '*.mp4' -o -iname '*.mov' \) |
    while IFS=$'\n' read -r FILE; do
        cmd=$(process_movie $FILE)
        echo $cmd
        eval $cmd || echo "error processing: $FILE"
    done
