#!/bin/bash


# main settings
DEFAULT_IP=192.168.195.53


# Second settings
MAIN_BRANCH_SERVER=origin/0.13.5.0
NODE_VERSION=16.17.1
COOP_MOD=SITCoop
COOP_BRANCH=0.13.5.0


# System settings
CURRENT_DIR=$(pwd)
SERVER_FOLDER=./Server
PROJECT_FOLDER=$SERVER_FOLDER/project
APP_FOLDER=./app
MODS_FOLDER=$APP_FOLDER/user/mods


DEFAULT_PATH=C:/snapshot/project/
TARGET_PATH=$(pwd)/app/


SERVER_PID=$(pgrep SPT-AKI)
LOG_FILE="$CURRENT_DIR/run.log"


ARGS1=$1
ARGS2=$2

# functions
change_ip() {
  echo "Change ip on $DEFAULT_IP in /Aki_Data/Server/configs/http.json, /user/mods/SITCoop/config/coopConfig.json"
  sed -i -e "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$DEFAULT_IP/g" ./Aki_Data/Server/configs/http.json;
  sed -i -e "s/[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}/$DEFAULT_IP/g" ./user/mods/SITCoop/config/coopConfig.json;
}

status() {
  if [ "$SERVER_PID" = "" ]; then
    echo "SPT-AKI server not run"
  else
    echo "SPT-AKI server is run"
    echo "Server pid: $SERVER_PID"
    echo "For kill server  ./run.sh kill"
    exit
  fi
}


echo "WARNINGS! ./run build REPLACE ON DEFAULT ALL CONFIG FILE FROM /Aki_Data/SERVER/configs !!!!!!!!!"


# check node version
if [ "$ARGS1" = "node_install" ]; then

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
    export NVM_DIR=$HOME/.nvm
    source $NVM_DIR/nvm.sh
    nvm install "$NODE_VERSION"
    npm install -g yarn
    npm install -g forever

  elif [ "$ARGS1" = "zerotier_install" ]; then

    curl -s https://install.zerotier.com | sudo bash

  elif [ "$ARGS1" = "zerotier_join" ]; then

    sudo zerotier-cli join $ARGS2

  elif [ "$ARGS1" = "build" ]; then

    # check node version
    if [ ! "$(node -v)" = "v$NODE_VERSION" ]; then
      export NVM_DIR=$HOME/.nvm
      source $NVM_DIR/nvm.sh
      nvm install "$NODE_VERSION"
    fi


    # copy from git
    echo "Update server ..."
    if [ ! -d ${SERVER_FOLDER} ]; then
      git clone -b $MAIN_BRANCH_SERVER https://dev.sp-tarkov.com/SPT-AKI/Server.git
    fi


    # pull from git
    cd $SERVER_FOLDER
    # git checkout $MAIN_BRANCH_SERVER
    git reset --hard $MAIN_BRANCH_SERVER
    git lfs pull
    cd $CURRENT_DIR


    # copy files
    echo "Start copy files..."
    mkdir -p $APP_FOLDER
    mkdir -p $APP_FOLDER/Aki_Data
    mkdir -p $APP_FOLDER/user
    mkdir -p $APP_FOLDER/user/mods
    cp $PROJECT_FOLDER/package.json $APP_FOLDER/package.json
    cp $PROJECT_FOLDER/.parcelrc $APP_FOLDER/.parcelrc
    cp $PROJECT_FOLDER/tsconfig.json $APP_FOLDER/tsconfig.json
    cp $PROJECT_FOLDER/base_tsconfig.json $APP_FOLDER/base_tsconfig.json
    cp -R $PROJECT_FOLDER/src $APP_FOLDER/src
    cp -R $PROJECT_FOLDER/src $APP_FOLDER/obj
    cp -R $PROJECT_FOLDER/assets $APP_FOLDER/Aki_Data/Server
    echo "End copy files."
		
		
    # build
    cd $APP_FOLDER
    yarn
    cd $CURRENT_DIR


    # end build
    echo "Just ./run.sh build_coop"
    echo "then ./run.sh mods_fix"
    echo "then ./run.sh server"
		
  elif [ "$ARGS1" = "build_coop" ]; then

    echo "Update coop mods ..."
    if [ ! -d ${MODS_FOLDER}/${COOP_MOD} ]; then
      cd $MODS_FOLDER
      git clone -b $COOP_BRANCH https://github.com/paulov-t/SIT.Aki-Server-Mod.git
      mv SIT.Aki-Server-Mod $COOP_MOD
      cd $CURRENT_DIR
    fi
		
		
    cd $MODS_FOLDER/$COOP_MOD
    git reset --hard $COOP_BRANCH
    git pull
		
		
    # end build
    echo "Just ./run.sh mods_fix"
    echo "then ./run.sh server"
	
  elif [ "$ARGS1" = "mods_fix" ]; then
		
    # fix mods
    cd $APP_FOLDER
    echo "Fix mods files:"
    for i in $( find ./user/mods -name "*.js" ); do
      if grep -q "$DEFAULT_PATH" ${i}; then
        echo ${i}
        sed -i "s@$DEFAULT_PATH@$TARGET_PATH@g" ${i}
      fi
    done
    echo "End fix."
    echo "Just ./run.sh server"

  elif [ "$ARGS1" = "kill" ]; then

    echo "Kill servers:"

    pkill -9 -f SPT-AKI
    pkill -9 -f npx
    pkill -9 -f forever
    pkill -9 -f node
    pkill -9 -f run.sh

  elif [ "$ARGS1" = "status" ]; then

    status

  elif [ "$ARGS1" = "server" ]; then

    status

    # prepare
    cd $APP_FOLDER
    export NVM_DIR=$HOME/.nvm
    source $NVM_DIR/nvm.sh
    nvm use "$NODE_VERSION"

    change_ip

    # run
    npx ts-node -r tsconfig-paths/register src/ide/ReleaseEntry.ts

  elif [ "$ARGS1" = "server_d" ]; then

    status

    # prepare
    cd $APP_FOLDER
    export NVM_DIR=$HOME/.nvm
    source $NVM_DIR/nvm.sh
    nvm use "$NODE_VERSION"

    change_ip

    # run
    npx forever start -v -o $LOG_FILE -c ts-node -r tsconfig-paths/register src/ide/ReleaseEntry.ts
    echo "Wait start ..."
    sleep 60
    echo "Start server. Enjoy! log in $LOG_FILE"

  else
	
    echo "For install node ./run.sh node_install"
    echo "For install zerotier ./run.sh zerotier_install"
    echo "For join zerotier ./run.sh zerotier_join <hash_server>"
    echo "For build server ./run.sh build"
    echo "For build coop mod ./run.sh build_coop"
    echo "For fix server mod files ./run.sh mods_fix"
    echo "Before run server, change ip in ./run.sh (DEFAULT_IP=)"
    echo "For run server ./run.sh server"
    echo "For run server in background ./run.sh server_d"
    echo "For status server ./run.sh status"
    echo "For kill server  ./run.sh kill"

fi

echo "--------------------------------------------------------------------------------------------"
