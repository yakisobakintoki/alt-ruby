#!/bin/bash
PROGNAME=$(basename $BASH_SOURCE)
VERSION="1.0"

#ver=2.1.2
function install_ruby
{
local ver=$1
local dstD=/usr/bin
local srcD=/opt/ruby-$ver/bin
#local list=(erb irb rake rdoc ri gem testrb bundle)
local slaves=""
local list="$(find $srcD -perm -u+x)"

for name in $list ; do
	name=$(basename "$name")
#for name in ${list[@]} ; do
	if [[ -e ${srcD}/$name && $name != "ruby"  ]] ; then
		local slave="--slave ${dstD}/$name $name ${srcD}/$name "
		slaves="$slaves""$slave"
	fi
done

update-alternatives --install ${dstD}/ruby ruby ${srcD}/ruby 500 $slaves

#update-alternatives --install ${dstD}/ruby ruby ${srcD}/ruby 500 \
#--slave ${dstD}/erb erb ${srcD}/erb \
#--slave ${dstD}/irb irb ${srcD}/irb \
#--slave ${dstD}/rake rake ${srcD}/rake \
#--slave ${dstD}/rdoc rdoc ${srcD}/rdoc \
#--slave ${dstD}/ri ri ${srcD}/ri \
#--slave ${dstD}/gem gem ${srcD}/gem \
#--slave ${dstD}/testrb testrb ${srcD}/testrb



}


exit_with(){
#	popd
	exit $1
}

usage() {
    echo "Usage: $PROGNAME [OPTIONS] FILE"
    echo "  Ruby の切り替え"
    echo
    echo "Options:"
    echo "  -h, --help"
    echo "      --version"
    echo "  -a, --add [ver] 選択対象ruby を追加"
    echo "  -r, --remove [ver] 選択対象ruby を削除"
    echo "  -s, --switch [ver] ruby を切り替える"
    echo "  -src, --src-list  未追加のruby一覧"
    echo "  -dst, --dst-list  追加済みのruby一覧"
    echo "  --reflesh-path PATHを更新 source alt-ruby --reflesh-path"
		echo "[ver] は 2.2.0 等の形式のバージョン識別子"
    echo
    exit_with 1
}
FUNC=""

for OPT in "$@"
do
    case "$OPT" in
        '-h'|'--help' )
            usage
            exit_with 1
            ;;
        '--version' )
            echo $VERSION
            exit_with 1
            ;;
        '-a'|'--add' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit_with 1
            fi
						FUNC="--add"
            ALT_RUBYVER="$2"
            shift 2
            ;;
        '-r'|'--remove' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit_with 1
            fi
						FUNC="--remove"
            ALT_RUBYVER="$2"
            shift 2
            ;;
        '-s'|'--switch' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit_with 1
            fi
						FUNC="--switch"
            ALT_RUBYVER="$2"
            shift 2
            ;;
        '-src'|'--src-list' )
						ls -1 /opt/ruby-*/bin/ruby
						exit_with 0
						;;
        '-dst'|'--dst-list' )
						update-alternatives --list ruby
						exit_with 0
						;;
        '--reflesh-path' )
						FUNC="--reflesh-path"
						;;
        '--'|'-' )
            shift 1
            param+=( "$@" )
            break
            ;;
        -*)
            echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2
            exit_with 1
            ;;
        *)
            if [[ ! -z "$1" ]] && [[ ! "$1" =~ ^-+ ]]; then
                #param=( ${param[@]} "$1" )
                param+=( "$1" )
                shift 1
            fi
            ;;
    esac
done
### ---- [ reflesh
	RubyVersion_to_bindir(){
		local ver=$(echo -n $1 | cut -d ' ' -f 2  | sed -e 's/p.*$//g')
		local bindir="/opt/ruby-$ver/bin"
		echo $bindir
	}
	clear_ruby_bin_path(){
		local paths1=$(echo -n $PATH)
		local paths2=$(echo -n $paths1 | sed -e 's/\:\/opt\/ruby-.\+\/bin//g')
#	echo $paths2
		export PATH=$paths2
	}
	attach_path_at_backSide(){
		local bin_dir=$1
		local paths1=$(echo -n $PATH:$bin_dir)
#	echo $paths1
		export PATH=$paths1
	}

reflesh_ruby_path()
{
	local ruby_version=$(ruby -v)
	local bindir=$(RubyVersion_to_bindir "$ruby_version")
		# tips 出力を戻り値にしたい場合は、 $()
		# 引数展開を禁止するため 引数は "$var"

	echo $bindir
	clear_ruby_bin_path
	attach_path_at_backSide "$bindir"
}
### ---- ]

get_now_version(){
	local ver=$(ruby -v)
	ver=$(echo -n $ver | cut -d ' ' -f 2  | sed -e 's/p.*$//g')
	echo $ver
}
if [ -z $ALT_RUBYVER ] ; then
	ALT_RUBYVER=$(get_now_version)
fi

alt_rubypath=/opt/ruby-$ALT_RUBYVER/bin/ruby
if [ ! -e $alt_rubypath ]; then
	echo error : not exist path "$alt_rubypath" 
	echo `update-alternatives --list ruby`
	exit_with 1
fi

echo $FUNC $alt_rubypath
case $FUNC in
		'--add' )
				install_ruby $ALT_RUBYVER	
				;;
		'--remove' )
				update-alternatives --remove ruby $alt_rubypath
				;;
		'--switch' )
				update-alternatives --set ruby $alt_rubypath
				reflesh_ruby_path
				;;
		'--reflesh-path' )
				reflesh_ruby_path
				;;
esac

