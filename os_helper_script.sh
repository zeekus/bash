#filename:os_helper_script.sh
#description: add this to your .bashrc on Windows. 
platform='unknown'
unamestr=$(uname -a)
if [[ "$unamestr" =~ "-Micro" ]]; then
  platform="Windows"
  echo "Windows detected"
  export DISPLAY=":0"
  #set paths in windows
  if [[ "$PATH" =~ cygdrive ]]; then
    echo "cygwin eviornment detected"
    myuser=$USER
    myroot="/cygdrive/c/Users/$myuser" 
  else
    echo "non cygwin eviornment detected"
    myuser=$NAME
    myroot="/mnt/c/Users/$myuser"
  fi
  mysite="Example Site"
  onedrive="OneDrive\ -\ $mysite"
  alias outlook_data="$myroot/AppData/Local/Microsoft/Outlook"
  alias mygit="cd $myroot/git"
  alias downloads="cd $myroot/Downloads"
  alias myhome="cd $myroot"
  alias docs="cd $myroot/$onedrive/Documents"
elif [[ "$unamestr" =~ "Linux" ]]; then
  platform="Linux"
  echo "Linux detected"
  #do something linux specific
else
  platform="Unknown"
  echo "Unknown OS detected"
fi 
