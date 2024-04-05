#!/bin/sh
# Folder which contains Blogging Scripts
blogFolder=~/work/blog-web
Terminal_1=$(xdotool getactivewindow)
cd $blogFolder
searchLatestID="xdotool search -pid $(pidof st | cut --delimiter " " --fields 1)"

# Spawn a Terminal
st &
Terminal_2=$(eval "$searchLatestID")

# First Terminal - Start Hugo Server and Place in Tag 9
sleep 0.05
xdotool windowactivate  $Terminal_1 type hugo\ server\ -D && xdotool windowactivate $Terminal_1 key "KP_Enter"
xdotool windowactivate  $Terminal_1 key --clearmodifiers  "Super+shift+9" 

# Second Terminal - Change Directory to Root Blog Project
sleep 0.05
xdotool windowactivate $Terminal_2 type cd\ $blogFolder && xdotool windowactivate $Terminal_2 key "KP_Enter"
xdotool windowactivate $Terminal_2 type clear && xdotool windowactivate $Terminal_2 key "KP_Enter"
xdotool windowactivate $Terminal_2 type ls && xdotool windowactivate $Terminal_2 key "KP_Enter"

# Spawn a browser with localhost URL
sleep 0.05
st &
broswerID=$(eval "$searchLatestID")
xdotool windowactivate $browserID type $(firefox -new-tab "localhost:1313") && xdotool windowactivate $browserID key "KP_Enter"
