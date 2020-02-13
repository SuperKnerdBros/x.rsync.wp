#!/bin/bash

while getopts d:i:k:u:c: option
do
  case "${option}"
    in
    d) X_DOMAIN=${OPTARG};;
    i) X_INSTANCE=${OPTARG};;
    k) X_KEY=${OPTARG};;
    u) X_USR=${OPTARG};;
    c) X_CONTENT=${OPTARG};;
  esac 
done 

required(){
  VAR="X_$1" 
  if [[ ${!VAR} = "" ]]
  then
    echo "$1 Required"
    exit
  fi
}

function xSync(){
  RSYNC="sudo rsync -r -a -v -e 'ssh -i $KEY'"
  sudo runuser -l root -c "${RSYNC} ${1}:${2} ${2}" 
  sudo runuser -l root -c "${RSYNC} ${2} ${1}:${2}" 
}

# GET REQUIRED VARS
required DOMAIN 
required INSTANCE 
required KEY
required USR 
required CONTENT 

# KEYS & PATHS
KEY="/home/$X_USR/.ssh/$X_KEY"
CONTENT="/var/www/$X_DOMAIN/public/$X_CONTENT"
UPLOADS="$CONTENT/uploads/"
PLUGINS="$CONTENT/plugins/"
THEMES="$CONTENT/themes/"
WFLOGS="$CONTENT/wflogs/"

# RUN CMDS
sudo runuser -l root -c "ssh-keyscan  $X_INSTANCE >> ~/.ssh/known_hosts" 
xSync "$X_USR@$X_INSTANCE" "$UPLOADS"
xSync "$X_USR@$X_INSTANCE" "$PLUGINS"
xSync "$X_USR@$X_INSTANCE" "$THEMES"
xSync "$X_USR@$X_INSTANCE" "$WFLOGS"
sudo runuser -l root -c "ssh-keygen -R $X_INSTANCE" 
