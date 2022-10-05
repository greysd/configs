#!/bin/bash
# packet:
# git


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function usage() {
  echo "usage $0 [options] 
		install vimrc

	options:
  -v | --vundle 
			install Vundle
	-g | --git
			copy from OS to git for pushing	
	"
}

function vundle() {
	if [[ -x $(command -v git) ]]; then 
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	else
		echo "no git installed, please install it first"
	fi
}
function copy() {
	cp -f ~/.vimrc $SCRIPT_DIR/
}

# parse arguments
while (($#)); do
  case $1 in
		"--") 
			break 2
			;;
		"-v" | "--vundle" )
			vundle
			shift
			;;
		"-g" | "--git"
		  copy
			GIT=true
		*)
			usage
			shift
			;;
	esac
done

# install vimrc
[[ -z $GIT ]] && cp -f ${SCRIPT_DIR}/.vimrc ~/


