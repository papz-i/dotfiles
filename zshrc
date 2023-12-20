# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Aliases
alias nv='nvim'
alias vim='nvim'
alias tr='trash'
alias c='clear'
alias ..='cd ..'
alias ls='ls -CF --color=auto'
alias ll='ls -lhisa --color=auto'
alias mkdir='mkdir -pv'
alias free='free -mt'
alias ps='ps auxf'
alias psgrep='ps aux | grep -v grep | grep -i -e VSZ -e'
alias wget='wget -c'
alias histg='history | grep'
alias grep='grep --color=auto'

clear

# PLUGINS
# 
# Powerlevel 10k
source ~/.config/zsh/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Autosuggestion
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax Highlighting
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# History search using UP and DOWN
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Autocompletion
source ~/.config/zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh


