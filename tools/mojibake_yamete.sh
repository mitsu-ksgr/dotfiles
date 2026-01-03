#!/usr/bin/env bash
#
# ディレクトリ内の文字化けしたヤツをリネームする.
#
#
set -u
umask 0022


i=1
find . -maxdepth 1 -mindepth 1 -printf '%i\t%f\0' |
while IFS=$'\t' read -r -d '' inode name; do
    #echo "inode: ${inode} ... ${name}"

    # echo は -e や \n の解釈が実装依存。
    # printf はバイト列をそのまま出す。
    printf '%s\n' "${name}" | iconv -f UTF-8 -t UTF-8 >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        fname="filename_fixed_${i}"
        i=$((i + 1))

        echo "Inavlid UTF-8 filename detected: inode(${inode}) - ${name} ---> ${fname}"

        # inode id を指定してファイル名を変更
        find . -maxdepth 1 -inum "${inode}" -exec mv {} "${fname}" \;
    fi
done


