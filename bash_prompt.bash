#!/bin/bash
#filename: prompt_confirm.bash
#description: request Y to continue


#only run manually input if run_manually is set to 1
prompt_confirm() {
  if [[ $run_manually -eq "1" ]]; then 
    #source https://stackoverflow.com/questions/3231804/in-bash-how-to-add-are-you-sure-y-n-to-any-command-or-alias
    while true; do
      read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
      case $REPLY in
        [yY]) echo ; return 0 ;;
        [nN]) echo ; exit 1 ;;
        *) printf " \033[31m %s \n\033[0m" "invalid input"
      esac 
    done  
  fi
}

run_manually=1
prompt_confirm