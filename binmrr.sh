#!/bin/bash
# sample
# sudo ./binmrr.sh  /opt/ruby-2.3.1/bin

if [ $# -le 0  ] ; then
    echo "ex : sudo binmrr  /opt/ruby-2.3.1/bin"
    exit
fi


srcbin=$1
i=""
dstbin=/opt/bin
for i in `find $srcbin` ; do
    path=$(realpath $i)
    if [ -x $i ] ; then
        ln -sf $path $dstbin/
    fi
done
