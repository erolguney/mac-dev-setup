# .zshrc

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Editor
export EDITOR='zed --wait'
export VISUAL='zed --wait'

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah'
alias la='ls -A'
alias gs='git status'
alias gd='git diff'
alias gco='git checkout'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias glog='git log --oneline --graph --decorate'
alias z='zed .'
alias c='cursor .'
alias brewup='brew update && brew upgrade && brew cleanup'

# PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# fnm (Node.js version manager)
eval "$(fnm env --use-on-cd)"
