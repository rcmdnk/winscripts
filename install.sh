#!/usr/bin/env bash

documents="/cygdrive/c/Users/$USER/Documents"
if [[ ! -d "$documents" ]];then
  documents="/mnt/c/Users/$USER/Documents"
  if [[ ! -d "$documents" ]];then
    echo "Run in Cygwin or Windows Subsystem for Linux"
    exit 1
  fi
fi

exclude=('.' '..' 'LICENSE' 'README.md' 'install.sh')
instdir="$HOME/usr/bin"

backup=""
overwrite=1
dryrun=0
newlink=()
exist=()
curdir=$(pwd -P)

# help
HELP="Usage: $0 [-ndsh] [-b <backup file postfix>] [-e <exclude file>] [-i <install dir>]

Make links of scripts (default:in $instdir)

Arguments:
      -b  Set backup postfix, like \"bak\" (default: \"\": no back up is made)
      -e  Set additional exclude file (default: ${exclude[*]})
      -i  Set install directory (default: $instdir)
      -n  Don't overwrite if file is already exist
      -d  Dry run, don't install anything
      -s  Use 'pwd' instead of 'pwd -P' to make a symbolic link
      -h  Print Help (this message) and exit
"
while getopts b:e:i:ndsh OPT;do
  case $OPT in
    "b" ) backup=$OPTARG ;;
    "e" ) exclude=("${exclude[@]}" "$OPTARG") ;;
    "i" ) instdir="$OPTARG" ;;
    "n" ) overwrite=0 ;;
    "d" ) dryrun=1 ;;
    "s" ) curdir=$(pwd) ;;
    "h" ) echo "$HELP" 1>&2; exit ;;
    * ) echo "$HELP" 1>&2; exit 1;;
  esac
done

if [[ "$OSTYPE" =~ "cygwin" ]];then
  # ln wrapper{{{
  function ln {
    opt="/H"
    if [ "$1" = "-s" ];then
      opt=""
      shift
    fi
    target="$1"
    if [ -d "$target" ];then
      opt="/D $opt"
    fi
    if [ $# -eq 2 ];then
      link="$2"
    elif [ $# -eq 1 ];then
      link=$(basename "$target")
    else
      echo "usage: ln [-s] <target> [<link>]"
      echo "       -s for symbolic link, otherwise make hard link"
      return
    fi
    t_winpath=$(cygpath -w -a "$target")
    t_link=$(cygpath -w -a "$link")
    cmd /c mklink $opt "$t_link" "$t_winpath" > /dev/null
  }
# }}}
fi

echo "**********************************************"
echo "Install X to $instdir/X"
echo "**********************************************"
echo
if [ $dryrun -ne 1 ];then
  mkdir -p "$instdir"
else
  echo "*** This is dry run, not install anything ***"
fi
for f in *;do
  for e in "${exclude[@]}";do
    flag=0
    if [ "$f" = "$e" ];then
      flag=1
      break
    fi
  done
  if [ $flag = 1 ];then
    continue
  fi
  install=1
  if [ $dryrun -eq 1 ];then
    install=0
  fi
  if [ "$(ls "$instdir/$f" 2>/dev/null)" != "" ];then
    exist=(${exist[@]} "$f")
    if [ $dryrun -eq 1 ];then
      echo -n ""
    elif [ $overwrite -eq 0 ];then
      install=0
    elif [ "$backup" != "" ];then
      mv "$instdir/$f" "$instdir/${f}.$backup"
    else
      rm "$instdir/$f"
    fi
  else
    newlink=(${newlink[@]} "$f")
  fi
  if [ $install -eq 1 ];then
    ln -s "$curdir/$f" "$instdir/$f"
  fi
done
echo ""
if [ $dryrun -eq 1 ];then
  echo "Following files don't exist:"
else
  echo "Following files were newly installed:"
fi
echo "  ${newlink[*]}"
echo
echo -n "Following files existed"
if [ $dryrun -eq 1 ];then
  echo "Following files exist:"
elif [ $overwrite -eq 0 ];then
  echo "Following files exist, remained as is:"
elif [ "$backup" != "" ];then
  echo "Following files existed, backups (*.$backup) were made:"
else
  echo "Following files existed, replaced old one:"
fi
echo "  ${exist[*]}"
echo
