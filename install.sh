#!/bin/bash
# packet:
# 


SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function usage() {
  echo "usage $0 [options] 
		install vimrc plugind vim and others

  options:
  -p | --pluginmanager 
      install Plugin manager vim-plug
  -g | --git 
      copy from OS to git for pushing	
  -i | --install
      install vim 9 on ubuntu (install repo, update packets, install vim 9)
  -n | --notcopy
      Do not copy vimrc from git to home
  -r | --install-vimrc
      Copy vimrc from git to OS
  -c | --install-colors
      Copy colors dirs from git in the Internet to vim
  -l | --install-light
      install light version of vimrc
	"
}

function pluginmanager() {
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

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
      pushd /tmp
      git clone https://github.com/vim/vim.git
      pushd vim/src
      make
      make test
      make install
      popd
      popd
			;;
		esac
}

 
function installvimrc() {
  [[ -z $DONOTCOPY ]] && [[ -f ${SCRIPT_DIR}/.vimrc ]] && cp -f ${SCRIPT_DIR}/.vimrc ~/ || curl -O ~/ https://raw.githubusercontent.com/greysd/configs/main/.vimrc
  curl -sL install-node.vercel.app/lts | sudo bash
  vim +PlugInstall +qall
  vim -c 'CocInstall -sync coc-tsserver coc-go coc-html coc-css coc-json|q'
  # git clone https://github.com/Shougo/neocomplete.vim.git ~/vim/
}

function installcolors() {
  TMPDIR=~/tmp
  [[ ! -d $TMPDIR ]] && DELETE=yes && mkdir $TMPDIR
  pushd $TMPDIR
  [[ -d $TMPDIR/vim-colorschemes ]] && rm -rf $TMPDIR/vim-colorschemes
  git clone https://github.com/flazz/vim-colorschemes.git
  cp -r vim-colorschemes/colors ~/.vim/colors
  popd
  [[ ! -z $TMPDIR ]] && rm -rf $TMPDIR 
}

function installlight() {
  echo "There is no light version yet"
}

# parse arguments
((!$#)) && usage
while (($#)); do
  case $1 in
		"--") 
			break 2
			;;
		"-p" | "--pluginmanager" )
			pluginmanager
			shift
			;;
		"-g" | "--git")
		  copy
			DONOTCOPY=true
			shift
			;;
		"-i" | "--install")
		  installvim9
      pluginmanager
      installvimrc
      installcolors
			shift
			;;
    "-r" | "--install-vimrc")
      installvimrc
      shift
      ;;
    "-c" | "--install-colors")
      installcolors
      shift
      ;;
    "-n" | "--notcopy")
      DONOTCOPY=true
      shift
      ;;
    "-l" | "--install-lighti")
      installlight
      shift
      ;;
		*)
			usage
			shift
			;;
	esac
done


