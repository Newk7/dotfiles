#!/usr/bin/env bash
# macOS dev environment bootstrap. Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
PYTHON_VERSION="3.13"

info() { printf "\n\033[1;34m==> %s\033[0m\n" "$*"; }

link() {  # link <src> <dest>: back up a real file, then symlink
  local src="$1" dest="$2"
  if [[ -e "$dest" && ! -L "$dest" ]]; then
    mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)"
    echo "backed up $dest"
  fi
  ln -sfn "$src" "$dest"
  echo "linked $dest -> $src"
}

info "Xcode Command Line Tools"
xcode-select -p >/dev/null 2>&1 || { xcode-select --install; echo "Re-run this script after CLT finishes installing."; exit 1; }

info "Homebrew"
if ! command -v brew >/dev/null && [[ ! -x /opt/homebrew/bin/brew ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

info "Brew packages + apps (Brewfile)"
brew bundle --file="$DOTFILES/Brewfile"

info "Python $PYTHON_VERSION via uv"
uv python install "$PYTHON_VERSION" --default
uv tool install ruff || true
uv tool install ipython || true

info "oh-my-zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone() { [[ -d "$2" ]] || git clone --depth=1 "$1" "$2"; }
clone https://github.com/romkatv/powerlevel10k.git              "$ZSH_CUSTOM/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions.git      "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting.git  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"

info "Linking dotfiles"
mkdir -p "$HOME/.config" "$HOME/work" "$HOME/projects"
link "$DOTFILES/zshrc"      "$HOME/.zshrc"
link "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
link "$DOTFILES"            "$HOME/.config/nvim"   # repo is laid out as an nvim config
[[ -f "$DOTFILES/p10k.zsh" ]] && link "$DOTFILES/p10k.zsh" "$HOME/.p10k.zsh"

info "Neovim providers (pynvim venv + node host)"
NVIM_PY="$HOME/.local/share/nvim-python"
[[ -x "$NVIM_PY/bin/python" ]] || uv venv "$NVIM_PY"
uv pip install --python "$NVIM_PY/bin/python" -q pynvim
npm install -g neovim >/dev/null 2>&1 || echo "npm -g neovim failed (optional)"

info "Neovim plugins + coc extensions"
nvim --headless +PlugInstall +qall >/dev/null 2>&1 || echo "nvim PlugInstall had errors; run :PlugInstall manually"
COC_EXT=$(sed -n "/coc_global_extensions/,/]/p" "$DOTFILES/plug-config/coc.vim" | grep -o "'coc-[a-z-]*'" | tr -d "'" | tr '\n' ' ')
nvim --headless "+CocInstall -sync $COC_EXT" +qall >/dev/null 2>&1 || echo "CocInstall had errors; run :CocInstall manually"

info "Language servers"
command -v go >/dev/null && go install golang.org/x/tools/gopls@latest

info "VS Code extensions"
if command -v code >/dev/null; then
  while read -r ext; do [[ -n "$ext" ]] && code --install-extension "$ext" --force >/dev/null && echo "  $ext"; done \
    < "$DOTFILES/vscode-extensions.txt"
fi

info "Done. Next steps:"
cat <<'EOF'
  1. Open iTerm2 -> Settings -> Profiles -> Text -> Font: "MesloLGS Nerd Font"
     Profiles -> Keys -> Left Option key: "Esc+"  (needed for tmux Alt-arrow pane switching)
  2. Run `exec zsh`, then `p10k configure` (then: cp ~/.p10k.zsh ~/dotfiles/p10k.zsh to save it)
EOF
