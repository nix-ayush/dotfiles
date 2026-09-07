PS1='\[\e[38;5;123;1m\]$(parse_git_branch)\[\e[0m\][\[\e[38;5;45;1m\]\u\[\e[91m\]@\[\e[38;5;45m\]\h\[\e[0m\]] \[\e[38;5;202;1m\]\t\[\e[0m\] \[\e[1m\]\w\[\e[0m\]\n\[\e[1m\]\$\[\e[0m\] '

# -- bash --
HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s extglob
shopt -s globstar
shopt -s checkjobs
shopt -s autocd

# -- custom: aliases --
alias ...='cd ../..'
alias ..='cd ..'
alias awc=/etc/nixos/scripts/aw_check.sh
alias c=clear
alias clean='sudo nix-collect-garbage -d'
alias cp='cp -riv'
alias cxn='clang++ -g -pedantic-errors -Wall -Wextra -Wshadow -Wconversion -Wsign-conversion -Werror'
alias cxx='cxn -std=c++23'
alias e='nnn -H'
alias errs='journalctl -p 3 -xb'
alias fo='fzf | xargs xdg-open'
alias fp='$EDITOR $(fzf --preview '\''bat --style=numbers --color=always --line-range :500 {}'\'' --border --layout=reverse)'
alias l='ls -lhaA'
alias logs='journalctl -f'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias rm=trash-put
alias rn='date +%d-%m-%Y___%H:%M:%S'
alias te=trash-empty
alias tl=trash-list
alias tp=trash-put
alias tr=trash-restore
alias usage='du -ahd1 | sort -rh'
alias x=exit
alias xwin='xprop | grep WM_CLASS'
alias ytb='yt-dlp -f "bestvideo[vcodec!=av01]+bestaudio/best" --merge-output-format mkv'


# -- custom: c++ --
cr() {
  if [ -z "$1" ]; then
    echo "Usage: cr <filename.cpp>"
  else
    cxx -o main.out "$@" && ./main.out
  fi
}

# -- custom: extract aac to m4a from mkv --
extract_rm_audio() {
    if [ -z "$1" ]; then
        echo "Error: Please provide an input file."
        echo "Usage: extract_audio \"filename.mkv\""
        return 1
    fi

    if [ ! -f "$1" ]; then
        echo "Error: File '$1' not found."
        return 1
    fi

    # Auto-detect the audio codec
    local codec
    codec=$(ffprobe -v error -select_streams a:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "$1")

    local ext
    case "$codec" in
        aac)  ext="m4a" ;;
        opus) ext="ogg" ;;
        mp3)  ext="mp3" ;;
        flac) ext="flac" ;;
        wav)  ext="wav" ;;
        *)    ext="mka" ;; # Fallback
    esac

    local base_name="${1%.*}"
    if ffmpeg -i "$1" -vn -c:a copy "${base_name}.${ext}"; then
        echo "OK: Moving original video to Trash!"

        if command -v trash &> /dev/null; then
            trash "$1"
        else
            echo "WARNING: 'trash' command not found!"
            # rm "$1"
        fi
    else
        echo "ERROR: Extraction failed!"
        return 1
    fi
}

# Filter 'Skip/Duplicate' lines and count the rest
count_fresh() {
    grep --line-buffered -vE "Skipping|Skip|Duplicate" | nl
}

# Auto-ls after changing directory
cd() {
  builtin cd "$@" && ls
}

# git
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# mpv/mpvpaper
# to play video directly on where is wallpaper xD
mpg() {
    mpvpaper -o "--hwdec=auto" "*" "$@"
}

# emacs
export ALTERNATE_EDITOR=""
alias emc="emacsclient -c"
alias emr="emacsclient -r"
alias emt="emacsclient -t"

# fzf
if [[ $- == *i* ]]; then
    eval "$(fzf --bash 2>/dev/null)"
fi
export FZF_DEFAULT_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type f"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --strip-cwd-prefix --hidden --exclude .git --type d"
export FZF_DEFAULT_OPTS="--layout=reverse --border"

# gallery-dl
alias gdl2='gallery-dl --option "extractor.r.level=2"'
gdr() {
    for arg in "$@"
    do
        gallery-dl "r:$arg"
    done
}

# -- kitty --
if test -n "$KITTY_INSTALLATION_DIR"; then
  export KITTY_SHELL_INTEGRATION="no-rc"
  source "$KITTY_INSTALLATION_DIR/shell-integration/bash/kitty.bash"
fi

# yazi
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# Deno
. "$HOME/.deno/env"
source "$HOME/.local/share/bash-completion/completions/deno.bash"

# Created by `pipx` on 2026-09-06 16:53:49
export PATH="$PATH:$HOME/.local/bin"
