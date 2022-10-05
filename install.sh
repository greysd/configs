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
	-i | --install
      install vim 9 on ubuntu (install repo, update packets, install vim 9)
  -n | --notcopy
      Do not copy vimrc from git to home
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

function installvim9() {
  OSVERS=$(cat /etc/*-release | awk -F'=' '/DISTRIB_ID/ { print $2}')
	case $OSVERS in
	  "Ubuntu")
      sudo add-apt-repository ppa:jonathonf/vim
      sudo apt -y update
      sudo apt -y install vim
			;;
	  *)
			echo "do not support others distributives"
			;;
		esac
}

function installvimrc() {
  [[ -z $DONOTCOPY ]] && cp -f ${SCRIPT_DIR}/.vimrc ~/
  vim +PluginInstall +qall
  # git clone https://github.com/Shougo/neocomplete.vim.git ~/vim/
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
		"-g" | "--git")
		  copy
			DONOTCOPY=true
			shift
			;;
		"-i" | "--install")
		  installvim9
			shift
			;;
    "-n" | "--notcopy")
      DONOTCOPY=true
      shift
      ;;
		*)
			usage
			shift
			;;
	esac
done

# install vimrc


