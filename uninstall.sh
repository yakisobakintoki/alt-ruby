#!/bin/bash
target_path=/usr/local/bin/alt-ruby
if [ -e $target_path ]; then
	if [ -L $target_path ]; then
		spath=$(realpath ./alt-ruby.sh)
		dpath=$(realpath ${target_path})
		if [[ $spath == $dpath   ]] ; then
			set -x
			unlink $target_path
			set +x
			echo uninstall OK: $target_path
		fi
	else
		echo failed: invalid installed $target_path.
	fi 
else
	echo failed :uninstalled $target_path.
fi

