# 1. Environment
alias go1='conda activate env1'
alias go='conda activate base'

# 2. Resilient System Sync
# - Safely links to the external dotfiles script if it exists
# - Handles apt-fast upgrades, strict 10m snap timeouts, and lock clearing
# - Ensures system cleanup and desktop notifications execute even if a snap hangs
if [ -f "$HOME/dotfiles/system-sync.sh" ]; then
    alias sync-system="$HOME/dotfiles/system-sync.sh"
fi


# 3. Shutdown Alias
# Using ; ensures it powers off even if there's a non-critical error in sync-system
alias bye='sync-system; poweroff'

### 4. Tmux Config
###alias tmux='tmux -f "$HOME/tmux_config"'

# 5. PostgreSQL aliases
alias startdb='psql -U sriman -h localhost'
alias startdb1='psql -U sriman -d sriman -h localhost'
alias startdb2='psql -U sriman -d postgres -h localhost'

# 6. Define the on-demand command for gitprompt
gitprompt() {
    # 1. Load the core Git script first
    if [ -f /usr/lib/git-core/git-sh-prompt ]; then
        . /usr/lib/git-core/git-sh-prompt
    fi

    # 2. Set your environment flags
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWCOLORHINTS=true

    # 3. Silently fetch upstream changes in background
   (git rev-parse --is-inside-work-tree >/dev/null 2>&1 && git fetch --quiet &) >/dev/null 2>&1

    # 3. Update the prompt string
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 " (%s)")\n\$ '
    
    echo "Git terminal polish activated! ✨"
}

# 7. Cleanup Command
alias cleanup="rm -rf ~/.cache/* && sudo /usr/bin/nice -n -5 /usr/bin/ionice -c2 -n0 /usr/bin/apt clean"

# 8. Mirror List update command
updateMirrorList() {
        sudo sed -i "0,/^\s*#*\s*MIRRORS=.*/{s|^\s*#*\s*MIRRORS=.*|MIRRORS=( $(cat /etc/apt/sources.list.d/nala-sources.list | grep -o 'http[s]*://[^ ]*' | sort -u | awk '{print "\x27" $0 "\x27,"}' | tr '\n' ' ' | sed 's/,$//') )|}" /etc/apt-fast.conf

}
# 9. Smaller alias for clearing the screen
alias cls='clear'
