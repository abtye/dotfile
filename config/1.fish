set TERM screen-256color

if status is-interactive
end

function fish_greeting
end

# pnpm
set -gx PNPM_HOME "/home/lin/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

fish_add_path /home/lin/.local/bin
#fish_add_path /usr/lib/jvm/java-21-openjdk/bin
#fish_add_path /home/lin/.local/dragonwell/bin
fish_add_path /home/lin/go/bin
fish_add_path /home/lin/.local/graalvm/bin


alias codew "code --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 --enable-features=WaylandWindowDecorations --ozone-platform-hint=wayland"

alias bim vim
alias cls "clear;ls"
alias ks ls
alias wss "waydroid session start"
alias wst "waydroid session stop"
alias wui "waydroid show-full-ui"
alias wdd waydroid
alias svim "sudo vim"
alias spac "sudo pacman"
alias pac pacman
alias c clear
alias s sudo
alias br brightnessctl
alias aap "aapt2 dump badging"
alias gc1 "git clone --depth=1"
alias gf1 "git fetch --depth=1"
alias p ping
alias pacmark "sudo pacman -D --asexplicit"
alias acg "advcp -g"
alias amg "advmv -g"
alias rlp realpath

set RUSTUP_DIST_SERVER "https://rsproxy.cn"
set RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"
