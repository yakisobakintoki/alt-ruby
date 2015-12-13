#!/bin/bash
spath=$(realpath ./alt-ruby.sh)
dpath=/usr/local/bin/alt-ruby
info_path=./installed-info.log
set -x
ln -sf $spath $dpath
chmod u+x $dpath
set +x
touch $info_path
echo "###$(date)" >> $info_path
echo ""
echo "* src:$spath"  >> $info_path
echo "* dst:$dpath"  >> $info_path
echo "* sha1sum:$(sha1sum $spath)" >> $info_path
echo "* intaller:$(realpath $0)" >> $info_path
echo "* unintaller:$(realpath ./uninstall.sh)" >> $info_path

