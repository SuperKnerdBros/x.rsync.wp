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

CMD1="ssh-keyscan  $X_INSTANCE >> ~/.ssh/known_hosts"
RSYNC="sudo rsync -r -a -v -e 'ssh -i $KEY'"
CMD2="$RSYNC $X_USR@$X_INSTANCE:$UPLOADS $UPLOADS"
CMD3="$RSYNC $X_USR@$X_INSTANCE:$PLUGINS $PLUGINS"
CMD4="$RSYNC $X_USR@$X_INSTANCE:$THEMES $THEMES"
CMD5="$RSYNC $X_USR@$X_INSTANCE:$WFLOGS $WFLOGS"
CMDX="ssh-keygen -R $X_INSTANCE"

sudo runuser -l root -c "${CMD1}; ${CMD2}; ${CMD3}; ${CMD4}; ${CMD5}; ${CMDX};" 
