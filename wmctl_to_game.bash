#!/bin/bash
#filename: wmctl_to_game.bash
#description: changes the focus on the window with a E.*${char} in the name.
char="zam" #3 letters from the Window Name
my_app=$(wmctrl -l|grep -i "E.*${char}"|sed -e s/.*\ E/E/g)

echo $my_app
wmctrl -a "${my_app}"
