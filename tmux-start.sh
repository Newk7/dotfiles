#!/bin/sh
#
# Setup for new tmux session script
# window has 3 panes. 
# The first pane (0) set at 90%, split vertically
# pane 1 is split at 50% and in default directory
# pane 2 is set to api root and bash prompt.
#

read -p "What will be the name of this session: " session
# set up tmux
tmux start-server

# create a new tmux session
tmux new-session -d -s $session

# Split pane 0 veritical by 90%
tmux selectp -t 0 
tmux splitw -h -p 5

# Select pane 1 
tmux selectp -t 1
tmux send-keys "cd ~/work" C-m

# Split pane 1 horizontal by 50%
tmux splitw -v -p 50

# Select pane 2 and set default directory
tmux selectp -t 2
tmux send-keys "cd ~/" C-m

# Select pane 0 and open nvim
tmux selectp -t 0
tmux send-keys "cd ~/work;nvim" C-m 

# Finished setup, attach to the tmux session!
tmux attach-session -t $session
