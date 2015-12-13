#!/bin/bash
PROGNAME=$(basename $0)
VERSION="1.0"

#ver=2.1.2
function install_ruby
{
ver=$1
dstD=/usr/bin
srcD=/opt/ruby-$ver/bin

update-alternatives --install ${dstD}/ruby ruby ${srcD}/ruby 500 \
--slave ${dstD}/erb erb ${srcD}/erb \
--slave ${dstD}/irb irb ${srcD}/irb \
--slave ${dstD}/rake rake ${srcD}/rake \
--slave ${dstD}/rdoc rdoc ${srcD}/rdoc \
--slave ${dstD}/ri ri ${srcD}/ri \
--slave ${dstD}/gem gem ${srcD}/gem \
--slave ${dstD}/testrb testrb ${srcD}/testrb
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
            VER="$2"
            shift 2
            ;;
        '-r'|'--remove' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit_with 1
            fi
						FUNC="--remove"
            VER="$2"
            shift 2
            ;;
        '-s'|'--switch' )
            if [[ -z "$2" ]] || [[ "$2" =~ ^-+ ]]; then
                echo "$PROGNAME: option requires an argument -- $1" 1>&2
                exit_with 1
            fi
						FUNC="--switch"
            VER="$2"
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

rubypath=/opt/ruby-$VER/bin/ruby
if [ ! -e $rubypath ]; then
	echo error : not exist path "$rubypath" 
	echo `update-alternatives --list ruby`
	exit_with 1
fi

echo $FUNC $rubypath
case $FUNC in
		'--add' )
				install_ruby $VER	
				;;
		'--remove' )
				update-alternatives --remove ruby $rubypath
				;;
		'--switch' )
				update-alternatives --set ruby $rubypath
				;;
esac

