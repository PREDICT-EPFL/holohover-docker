#!/bin/sh

# Set Session Name
SESSION="Holohover"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)

# Only create tmux session if it doesn't already exist
if ! [ "$SESSIONEXISTS" = "" ]
then
    tmux kill-session -t $SESSION
fi
# Start New Session with our name
tmux new-session -d -s $SESSION

tmux \
    split-window -v \; \
    split-window -h \; \
    split-window -h \; \
    split-window -v \; \
    split-window -v \; \
    select-layout tiled
    
sleep 0.1

tmux select-pane -t 1
tmux send-keys 'nc -vvv -lp 5000' C-m

tmux select-pane -t 2
tmux send-keys 'nc -vvv -lp 5001' C-m

tmux select-pane -t 3
tmux send-keys 'nc -vvv -lp 5002' C-m

tmux select-pane -t 4
tmux send-keys 'nc -vvv -lp 5003' C-m

tmux select-pane -t 5
tmux send-keys 'nc -vvv -lp 5004' C-m

tmux select-pane -t 0
tmux send-keys 'bash experiment.sh'


# Attach Session, on the Main window
tmux attach-session -t $SESSION
