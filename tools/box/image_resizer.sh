#!/bin/bash

#
# 1000枚くらい画像があって、全部 128x128 だったらよかったんだけど、
# いくつかの画像だけ 256x256 とか 64x64 が混じってたから、
# ガバッと 128x128 に揃える、みたいなのをやったときのスクリプト
#

target='./main/*.png'

flag=
for f in ${target} ; do
    size=$(identify -format "%w,%h" $f)
    w=${size%,*}
    h=${size##*,}

    #printf "%-40s\t%s x %s\n" $(basename $f) $w $h

    # 128x128 じゃない画像をリサイズする
    if [ "$w" != '128' ]; then
        flag='on'
        printf "%-40s\t%s x %s" $(basename $f) $w $h
        convert $f -resize 128x128 $f   # WARN: overwritten!
        echo ' ... resized.'
    fi
done

if [ -z "$flag" ]; then
    echo 'all image 128x128, OK!'
fi

