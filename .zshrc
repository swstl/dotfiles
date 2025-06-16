if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
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


zinit ice depth=1; zinit light romkatv/powerlevel10k


# Load completions
autoload -Uz compinit && compinit

# Add in zsh plugins
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions


# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

zinit cdreplay -q

# History
HISTSIZE=500000
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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'

# Handy change dir shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'
alias neofetch='fastfetch'

# Core Utils Aliases
alias l='eza -lh  --icons=auto'
alias ls='eza -1   --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias mkdir='mkdir -p'
alias ssh='kitten ssh'
alias tree='tree -a -I .git'
alias cat='bat'
alias c='clear' # clear terminal
alias e='exit'
alias mkdir='mkdir -p'
alias vim='nvim'
alias grep='rg --color=auto'
alias diff='colordiff'
alias rtop='radeontop'

# Git Aliases
alias gac='git add . && git commit -m'
alias gs='git status'
alias gpush='git push origin'
alias lg='lazygit'

# Downloads Aliases
alias yd='yt-dlp -f "bestvideo[height<=1080]+bestaudio" --embed-chapters --external-downloader aria2c --concurrent-fragments 8 --throttled-rate 100K'
alias td='yt-dlp --external-downloader aria2c -o "%(title)s."'
alias download='aria2c --split=16 --max-connection-per-server=16 --timeout=600 --max-download-limit=10M --file-allocation=none'

# VPN Aliases
# alias vpn-up='sudo tailscale up --exit-node=raspberrypi --accept-routes'
# alias vpn-down='sudo tailscale down'
alias vpn='expressvpnctl'

warp ()
{
    sudo systemctl "$1" warp-svc
}

# Other Aliases & Variables
alias apps-space='expac -H M "%011m\t%-20n\t%10d" $(comm -23 <(pacman -Qqe | sort) <(pacman -Qqg base base-devel | sort)) | sort -n'
alias files-space='sudo ncdu --exclude /.snapshots /'
alias ld='lazydocker'
alias cr='mpv --yt-dlp-raw-options=cookies-from-browser=brave'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT1'
alias y='yazi'
alias c='c'
lsfind ()
{
    ll "$1" | grep "$2"
}

# Update and Ugrade Arch
function up() {
  echo ":: Checking Arch Linux PGP Keyring..."
  local installedver="$(LANG= sudo pacman -Qi archlinux-keyring | grep -Po '(?<=Version         : ).*')"
  local currentver="$(LANG= sudo pacman -Si archlinux-keyring | grep -Po '(?<=Version         : ).*')"
  if [ $installedver != $currentver ]; then
    echo " Arch Linux PGP Keyring is out of date."
    echo " Updating before full system upgrade."
    sudo pacman -Sy --needed --noconfirm archlinux-keyring
  else
    echo " Arch Linux PGP Keyring is up to date."
    echo " Proceeding with full system upgrade."
  fi
  if (( $+commands[yay] )); then
    yay -Syu
  elif (( $+commands[trizen] )); then
    trizen -Syu
  elif (( $+commands[pacaur] )); then
    pacaur -Syu
  elif (( $+commands[aura] )); then
    sudo aura -Syu
  else
    sudo pacman -Syu
  fi
}


# Shell Intergrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# >>> hyprland scripts >>>
export START_INDEX=10
# <<< hyprland scripts <<<

# To customize prompt, run p10k configure or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/who/DevStuff/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/who/DevStuff/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/who/DevStuff/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/who/DevStuff/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# >>> language servers >>>
export PATH=$PATH:/usr/lib/qt6/bin
# <<< language servers <<<


# >>> sudoedit >>>
export EDITOR="$HOME/.config/Lazyvim/EDITOR.sh"  
export VISUAL="$HOME/.config/Lazyvim/EDITOR.sh"  
# <<< sudoedit <<< 

# >>> sddm >>>
export QML_XHR_ALLOW_FILE_READ=1
# <<< sddm <<<

# >>> vms >>> 
alias kali-start="~/DevStuff/VMs/kali.sh"
alias windows-start="~/DevStuff/VMs/windows.sh"
# <<< vms <<< 

# >>> stuff for shell custom shell scripts >>>
export GAME_ROOT_PATH="~/Documents/game/game"
export DISCRETE_PATH="~/Documents/school/diskret"
alias omnipotent="$GAME_ROOT_PATH/helper.sh"
alias gcd="python $DISCRETE_PATH/gcd.py"
alias lcm="python $DISCRETE_PATH/lcm.py"
alias prime="python $DISCRETE_PATH/prime.py"
alias base="python $DISCRETE_PATH/base.py"
alias sderivation="python $DISCRETE_PATH/string_derivation.py"
alias run='cd build && make && cd .. && ./$(find build/. -maxdepth 1 -type f -executable | head -n 1)'
# <<< 

# >>> wordlists: >>>
export seclists="/usr/share/seclists"
export rules="/usr/share/doc/hashcat/rules"
# <<<

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/Documents/school/ikt213g24h/godseye_github/godseye/apps/backend/inference/google-cloud-sdk/path.zsh.inc' ]; then . '~/Documents/school/ikt213g24h/godseye_github/godseye/apps/backend/inference/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/Documents/school/ikt213g24h/godseye_github/godseye/apps/backend/inference/google-cloud-sdk/completion.zsh.inc' ]; then . '~/Documents/school/ikt213g24h/godseye_github/godseye/apps/backend/inference/google-cloud-sdk/completion.zsh.inc'; fi

# >>> flutter >>>
export PATH="$PATH:~/DevStuff/flutter/bin"
export CHROME_EXECUTABLE="/usr/bin/firefox"
export FLUTTER_WEB_USE_SKIA=true
export PATH="~/DevStuff/flutter/bin:$PATH"
# <<< flutter <<<

# >>> ruby >>>
export PATH="$PATH:~/.gem/ruby/3.3.0/bin"
# <<< ruby <<<

# >>> java >>>
export JAVA_HOME=/opt/jdk-23
export PATH=$JAVA_HOME/bin:$PATH
# <<< java <<<

# >>> emscripten (webassembly:) >>> 
# >>> files are not added in dotfiles, remove if not needed
source /etc/profile.d/emscripten.sh
# <<< emscripten (webassembly:) <<<

# >>> nvim configurations >>>
# for fast commands:
alias nl="NVIM_APPNAME=Lazyvim nvim"
alias n="NVIM_APPNAME=mynvim nvim"

# to select the nvim config via terminal
function nvims() {
  items=('default' 'Lazyvim' 'mynvim')
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt="Neovim Config: " --height=~50% --layout=reverse --border --exit-0)

  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi

  NVIM_APPNAME=$config nvim $@
}

alias ns="nvims"
# if a keybinding i sneeded:
#bindkey -s ^n "nvims\n"

# <<< nvim configurations <<<
#

# >>> spacetimeDB >>>
export PATH="/stdb:$PATH"
# <<< spacetimeDB <<<
