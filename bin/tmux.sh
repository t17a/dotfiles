#!/bin/bash
 
# attach to an existing tmux session, or create one if none exist
# also set up access to the system clipboard from within tmux when possible
#
# e.g.
# https://gist.github.com/1462391
# https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard


# acording to http://mba-hack.blogspot.jp/2012/07/tmuxvi.html
 
if ! type tmux >/dev/null 2>&1; then
    echo 'Error: tmux command not found' 2>&1
    exit 1
fi
 
if [ -n "$TMUX" ]; then
    echo "Error: tmux session has already been attached" 2>&1
    exit 1
fi
 
if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
    # detached session exists
    tmux attach && echo "tmux attached session "
else
    if [[ ( $OSTYPE == darwin* ) && ( -x $(which reattach-to-user-namespace 2>/dev/null) ) ]]; then
        # on OS X force tmux's default command to spawn a shell in the user's namespace
        tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
        tmux -f <(echo "$tmux_config") new-session && echo "tmux created new session supported OS X"
    else
        tmux new-session && echo "tmux created new session"
    fi
fi

