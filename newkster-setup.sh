#!/bin/sh

set -o nounset    # error when referencing undefined variable
set -o errexit    # exit when command fails

installbasicsmac() { \
  # Get homebrew going
  xcode-select --install 
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  # ZSH
  brew install zsh
  chsh -s /bin/zsh
  #Iterm / node / yarn
  brew cask install iterm2
  brew install node
  brew install yarn
  # Install Iterm2
  brew cask install iterm2
  # Golang
  curl -o golang.pkg https://dl.google.com/go/go1.14.2.darwin-amd64.pkg
  sudo open golang.pkg
  # Python
  brew install python3
  python3 -m pip install pynvim
  # Install zsh and oh-my-zsh
  brew install zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  # Misc installs
  brew install git
  brew install fzf
  brew install ripgrep
  brew install the_silver_searcher
  brew install --HEAD universal-ctags/universal-ctags/universal-ctags
  brew install fd
  brew install tmux
  # Powerlevel10k
  git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k   
}

installbasicsubuntu() { \
  sudo apt-get update
  sudo apt-get upgrade
  #Install Dependencies for Alacritty
  sudo apt-get install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev python3
  #Installing Rust and Cargo for Alacritty
  curl https://sh.rustup.rs -sSf | sh
  cargo build --release
  #Install zsh
  sudo apt-get install zsh
  #Install and change to ZSH / Powerlevel10k DONT FORGET TO ADD ZSH_THEME in .zshrc
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  chsh -s /bin/zsh
  #Install Node
  sudo apt install nodejs
  sudo apt install npm
  sudo apt install yarn
  #Python pip and pynvim
  sudo apt-get install python3.8
  sudo apt install python3-pip > /dev/null
  pip3 install pynvim --user
  #copy and paste
  sudo apt install xsel
  #Install Go
  sudo tar -C /usr/local -xzf go1.15.4.linux-amd64.tar.gz
  sudo export PATH=$PATH:/usr/local/go/bin
  # Misc installs
  sudo apt-get install git
  sudo apt-get install fzf
  sudo apt-get install ripgrep
  sudo apt-get install silversearcher-ag
  sudo apt-get install universal-ctags
  sudo apt-get install fd
  sudo apt-get install tmux
  sudo apt-get install terraform
  # Powerlevel10k
  git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
}

installbasics() { \
  echo "Installing basics..."
  [ "$(uname)" == "Darwin" ] && installbasicsmac
  [  -n "$(uname -a | grep Ubuntu)" ] && installbasicsubuntu
  [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ] && echo "Windows not currently supported"
  sudo npm i -g neovim
}

##### Create Dirs #####
mkdir -p ~/work
mkdir -p ~/projects/

# Clone setup
if [ -d "~/.config/nvim" ]
then 
  git clone https://github.com/Newkster1/dotfiles.git ~/.config/nvim
else 
  mkdir -p ~/.config/nvim
  git clone https://github.com/Newkster1/dotfiles.git ~/.config/nvim

# Replacing key user files
cp ~/.config/nvim/.p10k.zsh ~/
cp ~/.config/nvim/.tmux.conf ~/
cp ~/.config/nvim/.zshrc ~/
# Copy Alacritty set up if ubuntu
[ -n "$(uname -a | grep Ubuntu)" ] && cp -r ~/.config/nvim/alacritty ~/.config

#I would recommend changing ubuntu window size terminal title bar

# /* shrink headerbars (don't forget semicolons after each property) */
#headerbar {
#  min-height: 0px;
#  padding-left: 2px; /* same as childrens vertical margins for nicer proportions */
#  padding-right: 2px;
#  background-color: #2d2d2d;
#}
#
#headerbar entry,
#headerbar spinbutton,
#headerbar button,
#headerbar separator {
#  margin: 0px;
#}
#
#/* shrink ssd titlebars */
#.default-decoration {
#  min-height: 0; /* let the entry and button drive the titlebar size */
#  padding: 0px;
#  background-color: #2d2d2d;
#}
#
#.default-decoration .titlebutton {
#  min-height: 0px; /* tweak these two props to reduce button size */
#  min-width: 20px;
#}
#
#window.ssd headerbar.titlebar {
#  padding-top: 2px;
#  padding-bottom: 2px;
#  padding-right: 6px;
#  min-height: 0;
#}
#
#window.ssd headerbar.titlebar button.titlebutton {
#  padding-top: 2px;
#  padding-bottom: 2px;
#  min-height: 0;
#}
