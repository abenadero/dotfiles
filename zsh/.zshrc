# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt extendedglob nomatch
unsetopt autocd beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/abenadero/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Personalized PROMPT
setopt PROMPT_SUBST

PROMPT=$'%F{10}%B%n::%m%b ➜ %F{11}%~\n%F{6}❯%f '

# Sugerencias basadas en el historial
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Resaltado de sintaxis
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
