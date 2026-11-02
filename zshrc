# Powerlevel10k instant prompt (keep near top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew (Apple Silicon)
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# User-local tools (no admin): uv, python, nvim, go, fzf, fd, rg, yarn, npm -g
export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
export EDITOR="nvim"

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
command -v fzf  >/dev/null && plugins+=(fzf)
command -v tmux >/dev/null && plugins+=(tmux)
source "$ZSH/oh-my-zsh.sh"

# fzf key bindings (Ctrl-R history, Ctrl-T files)
command -v fzf >/dev/null && source <(fzf --zsh)

# Python via uv
alias py="uv run python"
alias venv="uv venv && source .venv/bin/activate"

alias vim="nvim"
alias ts="~/dotfiles/tmux-start.sh"

# Machine-local overrides (not in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# Run `p10k configure` to create/redo this
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
