# Get homebrew going
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

##### Create Dirs #####
mkdir -p ~/work
mkdir -p ~/projects/

##### Run Installs #####

# Install Iterm2
brew cask install iterm2

# NeoVim
brew install neovim

# Golang
curl -o golang.pkg https://dl.google.com/go/go1.14.2.darwin-amd64.pkg
sudo open golang.pkg

# Python
brew install python3
python3 -m pip install pynvim

# Node
# Install Node Version Manager
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.0/install.sh | zsh
nvm install node
brew install node
npm i -g neovim

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
brew install node
brew install yarn
brew install tmux

# Powerlevel10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Clone setup
if [ -d "~/.config/nvim" ]
then 
  git clone https://github.com/Newk7/.dotfiles.git ~/.config/nvim
else 
  mkdir -p ~/.config/nvim
  git clone https://github.com/Newk7/.dotfiles.git ~/.config/nvim

# Replacing key user files
cp ~/.config/nvim/.p10k.zsh ~/
cp ~/.config/nvim/.tmux.conf ~/
cp ~/.config/nvim/.zshrc ~/
