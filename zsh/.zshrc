if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Prompt
eval "$(starship init zsh)"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
# zinit light jeffreytse/zsh-vi-mode

# 1. Load the core git library first (resolves git_current_branch)
zinit snippet OMZL::git.zsh

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
zinit snippet OMZP::python

# Load completions (Docker CLI completions live in ~/.docker/completions)
fpath=(~/.docker/completions $fpath)
autoload -Uz compinit && compinit

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
export PATH="$HOME/.cargo/bin:$PATH"

export EZA_CONFIG_DIR="$HOME/.config/eza"
# export PYENV_ROOT="/Users/ashishnayan/.pyenv"
#
export VISUAL=nvim;
export EDITOR=nvim;
# 
# Ranger FilePreview Colorscheme
export PYGMENTIZE_STYLE=gruvbox-dark
# export LS_COLORS="$(vivid generate molokai)"
export LS_COLORS="$(vivid generate catppuccin-mocha)"
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
alias sshprod="ssh prodro@54.151.183.173 -i ~/.ssh/id_rsa"

# django alias
alias drs="python manage.py runserver"
alias dmk="python manage.py makemigrations"
alias dm="python manage.py migrate"
alias ds="python manage.py shell"
# alias nac="source nvim-venv/bin/activate && source .env"
alias n="nvim"
alias savii="cd ~/projects/savii/api/ && aa"
# alias ls="lsd --group-dirs first"
# alias l="ls -lart"
alias rmq="docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.8.9-management"
# Standard grid replacement for ls with icons and folders sorted first
alias ls='eza --icons --group-directories-first'

# The "everything" view: detailed info, human-readable sizes, Git status, and headers
alias ll='eza -lh --icons --git --group-directories-first --header'

# Comprehensive view showing all hidden files
alias la='eza -lah --icons --git --group-directories-first'

# Two-level deep tree view using native elements
alias lt='eza --tree --level=2 --icons'

alias l=la

# zprof

# Throttle brew autoupdate instead of disabling it, so metadata never goes
# stale enough to hide an available upgrade (e.g. claude-code)
export HOMEBREW_AUTO_UPDATE_SECS="86400"

# Added by Amplify CLI binary installer
# export PATH="$HOME/.amplify/bin:$PATH"
# eval "$(uv generate-shell-completion zsh)"
# eval "$(uvx --generate-shell-completion zsh)"
# . "/Users/ashishnayan/.deno/env"
export PATH="$HOME/.local/bin:$PATH" # stowed `scripts` package lives here
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


for f in ~/dotfiles/zsh/functions/*.zsh; do
  source "$f"
done

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# JAVA HOME
alias use_java21="export JAVA_HOME=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
alias use_java26="export JAVA_HOME=/opt/homebrew/opt/openjdk@26/libexec/openjdk.jdk/Contents/Home"
