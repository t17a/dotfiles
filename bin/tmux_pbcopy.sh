#!/bin/sh
if ! type pbcopy >/dev/null 2>&1 || ! type reattach-to-user-namespace >/dev/null 2>&1; then
    tmux display-message "Error: cannot copy to clipboard."
    exit 0
fi
 
COPY=`tmux save-buffer -`
echo "$COPY" | reattach-to-user-namespace pbcopy
 
# メッセージ表示
LINES=`echo "$COPY" | wc -l | tr -d ' '`
tmux display-message "Copy: $LINES lines"
