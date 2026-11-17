# find a value in a json object using path (e.g. a.b.c)
jqfind() {
  /nix/store/5gzyrb8fdgqcj9qyg0dhz5c20m0k4b78-jq-1.8.2-bin/bin/jq '{"path": ([path(.. | select('$1'))|map(if type=="number" then "[\(.)]" else tostring end)|join(".")|split(".[]")|join("[]")]|unique|map("."+.)|.[]), "value": (.. | select('$1'))}'
}

# find and replace
rgr() {
  rg --null -l "$1" | xargs -0 sed -i "s/$1/$2/g"
}

# Sync bach history across terminal windows
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTCONTROL=erasedups:ignoredups:ignorespace
HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend

# Aliases
alias -- ~='cd ~'
alias -- ..='cd ..'
alias -- ...='cd ../..'
alias -- ....='cd ../../..'
alias -- .....='cd ../../../..'
alias -- ......='cd ../../../../..'

alias -- eza='eza --icons auto --color auto --git'

alias -- ls=eza
alias -- la='eza -al'
alias -- ll='eza -l'
alias -- lt='eza --tree'

alias -- ltmp='fd --one-file-system --base-directory / --type f --hidden --exclude "{tmp,etc/passwd,home/jeosas/.cache}"'

alias -- fd='fd --hidden'

alias -- nv=nvim

if [[ -n "${GHOSTTY_RESOURCES_DIR}" ]]; then
  builtin source "${GHOSTTY_RESOURCES_DIR}/shell-integration/bash/ghostty.bash"
fi

if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
  eval "$(fzf --bash)"
fi

if [ "$TERM" = xterm-ghostty ]; then
  fastfetch
fi

eval "$(direnv hook bash)"

if [[ $TERM != "dumb" ]]; then
  eval "$(starship init bash --print-full-init)"
fi
