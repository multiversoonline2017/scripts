#!/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your LIBERTY Coin masternodes.        *"
echo "****************************************************************************"
echo && echo && echo
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!                                                 !"
echo "! Make sure you double check before hitting enter !"
echo "!                                                 !"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo && echo && echo

echo "Do you want to install all needed dependencies (no if you did it before)? [y/n]"
read DOSETUP

if [[ $DOSETUP =~ "y" ]] ; then
  sudo apt-get update
  sudo apt-get upgrade
  sudo apt install make
  sudo apt install aptitude -y
  sudo apt-get update -y
  sudo apt-get upgrade -y
  sudo apt-get install -y ufw
  sudo ufw allow 22/tcp
  sudo ufw limit 22/tcp
  sudo ufw allow 10417/tcp
  sudo ufw logging on
  sudo ufw --force enable

  cd /var
  fallocate -l 3000M /mnt/3000MB.swap
  dd if=/dev/zero of=/mnt/3000MB.swap bs=1024 count=3072000
  mkswap /mnt/3000MB.swap
  swapon /mnt/3000MB.swap
  chmod 600 /mnt/3000MB.swap
  echo '/mnt/3000MB.swap  none  swap  sw 0  0' >> /etc/fstab
  cd

  ## COMPILE AND INSTALL
  wget https://s3.amazonaws.com/liberty-builds/5.2.1.0/linux-x64.tar.gz
  tar xvzf linux-x64.tar.gz
  sudo chmod 755 liberty*
  sudo mv liberty* /usr/bin
  sudo rm linux-x64.tar.gz
  
  
  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

## Setup conf
mkdir -p ~/bin
IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
NAME="libertycoin"


MNCOUNT=""
re='^[0-9]+$'
while ! [[ $MNCOUNT =~ $re ]] ; do
   echo ""
   echo "How many nodes do you want to create on this server?, followed by [ENTER]:"
   read MNCOUNT
done

for i in `seq 1 1 $MNCOUNT`; do
  echo ""
  echo "Enter alias for new node"
  read ALIAS  

  echo ""
  echo "Enter port for node $ALIAS (Any valid free port matching config from steps before: i.E. 10417)"
  read PORT

  echo ""
  echo "Enter RPC Port (Any valid free port: i.E. 11417)"
  read RPCPORT

  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY

  ALIAS=${ALIAS,,}
  CONF_DIR=~/.${NAME}_$ALIAS
  CONF_FILE=liberty.conf

  # Create scripts
  echo '#!/bin/bash' > ~/bin/${NAME}d_$ALIAS.sh
  echo "${NAME}d -daemon -conf=$CONF_DIR/${NAME}.conf -datadir=$CONF_DIR "'$*' >> ~/bin/${NAME}d_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/${NAME}-cli_$ALIAS.sh
  echo "${NAME}-cli -conf=$CONF_DIR/${NAME}.conf -datadir=$CONF_DIR "'$*' >> ~/bin/${NAME}-cli_$ALIAS.sh
  echo '#!/bin/bash' > ~/bin/${NAME}-tx_$ALIAS.sh
  echo "${NAME}-tx -conf=$CONF_DIR/${NAME}.conf -datadir=$CONF_DIR "'$*' >> ~/bin/${NAME}-tx_$ALIAS.sh 
  chmod 755 ~/bin/${NAME}*.sh

  mkdir -p $CONF_DIR
  echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> ${NAME}.conf_TEMP
  echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> ${NAME}.conf_TEMP
  echo "rpcallowip=127.0.0.1" >> ${NAME}.conf_TEMP
  echo "rpcport=$RPCPORT" >> ${NAME}.conf_TEMP
  echo "listen=1" >> ${NAME}.conf_TEMP
  echo "server=1" >> ${NAME}.conf_TEMP
  echo "daemon=1" >> ${NAME}.conf_TEMP
  echo "logtimestamps=1" >> ${NAME}.conf_TEMP
  echo "maxconnections=16" >> ${NAME}.conf_TEMP
  echo "masternode=1" >> ${NAME}.conf_TEMP
  echo "" >> ${NAME}.conf_TEMP

  echo "" >> ${NAME}.conf_TEMP
  echo "port=$PORT" >> ${NAME}.conf_TEMP
  echo "masternodeaddr=$IP:$PORT" >> ${NAME}.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> ${NAME}.conf_TEMP

  echo "addnode=199.247.11.85" >> $CONF_DIR/$CONF_FILE
  echo "addnode=140.82.33.117" >> $CONF_DIR/$CONF_FILE
  echo "addnode=108.61.211.79" >> $CONF_DIR/$CONF_FILE
  echo "addnode=45.76.89.208" >> $CONF_DIR/$CONF_FILE
  echo "addnode=139.180.210.118" >> $CONF_DIR/$CONF_FILE
  echo "addnode=45.77.136.188" >> $CONF_DIR/$CONF_FILE
  echo "addnode=95.179.160.237" >> $CONF_DIR/$CONF_FILE
  echo "addnode=209.250.244.112" >> $CONF_DIR/$CONF_FILE
  echo "addnode=207.246.110.199" >> $CONF_DIR/$CONF_FILE
  echo "addnode=82.239.216.33" >> $CONF_DIR/$CONF_FILE
  echo "addnode=149.28.237.181" >> $CONF_DIR/$CONF_FILE
  echo "addnode=104.236.96.7" >> $CONF_DIR/$CONF_FILE
  sudo ufw allow $PORT/tcp

  mv ${NAME}.conf_TEMP $CONF_DIR/${NAME}.conf
    
  sh ~/bin/${NAME}d_$ALIAS.sh
done
