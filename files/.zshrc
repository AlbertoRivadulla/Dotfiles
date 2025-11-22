#                                                        
#                         ,dPYb,                         
#                         IP'`Yb                         
#                         I8  8I                         
#                         I8  8'                         
#       ,gggg,    ,g,     I8 dPgg,    ,gggggg,    ,gggg, 
#      d8"  Yb   ,8'8,    I8dP" "8I   dP""""8I   dP"  "Yb
#     dP    dP  ,8'  Yb   I8P    I8  ,8'    8I  i8'      
#   ,dP  ,adP' ,8'_   8) ,d8     I8,,dP     Y8,,d8,_    _
#   8"   ""Y8d8P' "YY8P8P88P     `Y88P      `Y8P""Y8888PP
#         ,d8I'                                          
#       ,dP'8I                                           
#      ,8"  8I     zsh configuration file                
#      I8   8I                                           
#      `8, ,8I                                           
#       `Y8P"                                            


#############################################
#
# To set zsh as the default shell:
#     chsh -s $(which zsh)
# Then logout and login again
#
#############################################


# Powerlevel10k configuration
# {{{

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

MIN_ZSH_VERSION=5.1.0
THE_ZSH_VERSION=`echo $ZSH_VERSION`
if [ $(version $THE_ZSH_VERSION) -ge $(version $MIN_ZSH_VERSION) ]; then
  # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
  # Initialization code that may require console input (password prompts, [y/n]
  # confirmations, etc.) must go above this block; everything else may go below.
  source ~/powerlevel10k/powerlevel10k.zsh-theme
#  source $HOME/powerlevel10k/powerlevel10k.zsh-theme
  if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
  fi
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
else
  function whoismyhost (){
    a="$(ip route get 1 | awk '{print $NF;exit}')"
    b=`echo "$a" | sed 's/^.*\.\([^.]*\)$/\1/'`
    #echo $a
    #echo $b
    if [[ $a == 172.16.57.* ]]; then
      echo "gpu"$b
    elif [[ $a == 172.16.58.1 ]]; then
      echo "master"
    elif [[ $a == 193.144.80.1 ]]; then
      echo "pool"
    else
      echo "nodo0"$b
    fi
  }
  export CURRENT_HOST="$(whoismyhost)"
fi

# }}}

# Completions and suggestions {{{

# history settings {{

# save history
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=999999999
export SAVEHIST=999999999
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# }}

# zsh-autosuggestions {{

source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Try history first, then fall back to completion
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=241'
# # Accept a single word with the right arrow
# bindkey '^[[C' forward-word
# Accept whole suggestion with Ctrl+F (recommended)
bindkey '^F' autosuggest-accept

# }}

# native completion {{

# Initialize completion system AFTER Oh My Zsh
autoload -Uz compinit && compinit -i

CASE_SENSITIVE="false"
# setopt MENU_COMPLETE
setopt no_list_ambiguous

# The following makes completion case insensitive, and ignore punctuation differences at the end and beginning
# of the string
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=' 'l:|= r:|='
ls_colors="di=1;34:ln=36:so=35:pi=33:ex=32:bd=40;33:cd=40;33:su=37;41:sg=30;43:tw=30;42:ow=34;42"
zstyle ':completion:*:default' list-colors "${(s.:.)ls_colors}"
zstyle ':completion::cd:' tag-order local-directories directory-stack path-directories
zstyle ':completion::cd::directory-stack' menu yes select
zstyle ':completion:*' menu select
zstyle ':completion::-command-::' verbose false
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
 
# Shift+Tab to go back over the list of suggestions
bindkey '^[[Z' reverse-menu-complete
 
# }}


# }}}

# Coloring {{{

# colorize
export LSCOLORS=GxFxCxDxBxegedabagaced
alias ls="ls --color='auto'"

# Syntax highlighting
source $HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# }}}
 
# finishing {{{

# source local config file, if exists
[[ -f "$HOME/.zshrc_local" ]] && source $HOME/.zshrc_local

# check whether tmux is running or not, and export variable
if [ -n "$TMUX" ]; then
  export IS_TMUX=1
else
  if [ -z ${IS_TMUX+x} ]; then
    export IS_TMUX=0
  fi
fi

# }}}

# Custom functions
function sshx (){
  ssh -t $1 "export IS_TMUX=${IS_TMUX}; zsh"
}

