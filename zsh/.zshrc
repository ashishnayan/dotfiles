# zmodload zsh/zprof
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light jeffreytse/zsh-vi-mode

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::python

# Load completions
autoload -Uz compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -v
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:/Applications/WezTerm.app/Contents/MacOS/:$PATH"
export PYENV_ROOT="/Users/ashishnayan/.pyenv"
#
export VISUAL=nvim;
export EDITOR=nvim;
# 
# Ranger FilePreview Colorscheme
export PYGMENTIZE_STYLE=gruvbox-dark
export LS_COLORS="$(vivid generate molokai)"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export DISABLE_AUTO_TITLE='true'
export PYTHON_VENV_NAME='.venv'
export PYTHON_AUTO_VRUN=true

# Aliases
# alias ls='ls --color'
alias c='clear'

# Activate environment
alias ap='source $(poetry env info --path)/bin/activate && source .env'
alias aa="source nvim-venv/bin/activate && source .env"

# alias sshuat="ssh uat@uatserver.uplaon.ph -i ~/.ssh/id_rsa"
alias sshuat="ssh uat@54.254.173.33 -i ~/.ssh/id_rsa"
alias sshdev="ssh dev@devserver.uploan.ph -i ~/.ssh/id_rsa"

# django alias
alias drs="python manage.py runserver"
alias dmk="python manage.py makemigrations"
alias dm="python manage.py migrate"
alias ds="python manage.py shell"
# alias nac="source nvim-venv/bin/activate && source .env"
alias n="nvim"
alias savii="cd ~/projects/savii/api/ && aa"
alias ls="lsd --group-dirs first"
alias l="ls -lart"
alias rmq="docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.8.9-management"
alias sshcdev="ssh dev@dev.legal-ai-hub.in"
# zprof
