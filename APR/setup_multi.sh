#!/bin/bash

cd ~
echo "****************************************************************************"
echo "* Ubuntu 16.04 is the recommended opearting system for this install.       *"
echo "*                                                                          *"
echo "* This script will install and configure your APR Coin masternodes.        *"
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
  sudo apt-get -y upgrade
  sudo apt-get -y dist-upgrade
  sudo apt-get install -y nano htop git
  sudo apt-get install -y software-properties-common
  sudo apt-get install -y build-essential libtool autotools-dev pkg-config libssl-dev
  sudo apt-get install -y libboost-all-dev
  sudo apt-get install -y libevent-dev
  sudo apt-get install -y libminiupnpc-dev
  sudo apt-get install -y autoconf
  sudo apt-get install -y automake unzip
  sudo add-apt-repository  -y  ppa:bitcoin/bitcoin
  sudo apt-get update
  sudo apt-get install -y libdb4.8-dev libdb4.8++-dev
  sudo apt-get install libzmq-5* -y

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

  ## COMPILE AND INSTALL
  https://github.com/APRCoin/zenith-repository/releases/download/V3.0/aprcoin-v3.0.0-linux.zip
  unzip aprcoin-v3.0.0-linux.zip
  sudo chmod 755 Ubuntu/aprcoin*
  sudo mv Ubuntu/aprcoin* /usr/bin
  sudo mv aprcoin* /usr/bin

  sudo apt-get install -y ufw
  sudo ufw allow ssh/tcp
  sudo ufw limit ssh/tcp
  sudo ufw logging on
  echo "y" | sudo ufw enable
  sudo ufw status

  mkdir -p ~/bin
  echo 'export PATH=~/bin:$PATH' > ~/.bash_aliases
  source ~/.bashrc
fi

## Setup conf
mkdir -p ~/bin
IP=`ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'`
wget https://github.com/XeZZoR/scripts/raw/master/APR/peers.dat -O apr_peers.dat
NAME="aprcoin"


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
  echo "Enter port for node $ALIAS (Any valid free port matching config from steps before: i.E. 8001)"
  read PORT

  echo ""
  echo "Enter RPC Port (Any valid free port: i.E. 9001)"
  read RPCPORT

  echo ""
  echo "Enter masternode private key for node $ALIAS"
  read PRIVKEY

  ALIAS=${ALIAS,,}
  CONF_DIR=~/.${NAME}_$ALIAS
  CONF_FILE=aprcoin.conf

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
  echo "maxconnections=256" >> ${NAME}.conf_TEMP
  echo "masternode=1" >> ${NAME}.conf_TEMP
  echo "" >> ${NAME}.conf_TEMP

  echo "" >> ${NAME}.conf_TEMP
  echo "port=$PORT" >> ${NAME}.conf_TEMP
  echo "masternodeaddr=$IP:$PORT" >> ${NAME}.conf_TEMP
  echo "masternodeprivkey=$PRIVKEY" >> ${NAME}.conf_TEMP

    echo "addnode=45.77.227.93" >> $CONF_DIR/$CONF_FILE
    echo "addnode=18.191.175.138" >> $CONF_DIR/$CONF_FILE
    echo "addnode=18.188.93.12" >> $CONF_DIR/$CONF_FILE
    echo "addnode=85.214.199.57" >> $CONF_DIR/$CONF_FILE
    echo "addnode=18.222.190.189" >> $CONF_DIR/$CONF_FILE
    echo "addnode=3.16.148.30" >> $CONF_DIR/$CONF_FILE
    echo "addnode=209.97.183.127" >> $CONF_DIR/$CONF_FILE
    echo "addnode=3.16.166.214" >> $CONF_DIR/$CONF_FILE
    echo "addnode=108.61.175.177" >> $CONF_DIR/$CONF_FILE
    echo "addnode=142.93.32.206" >> $CONF_DIR/$CONF_FILE
    echo "addnode=178.128.166.102" >> $CONF_DIR/$CONF_FILE
    echo "addnode=140.82.29.242" >> $CONF_DIR/$CONF_FILE
    echo "addnode=104.156.232.221" >> $CONF_DIR/$CONF_FILE
    echo "addnode=167.99.160.210" >> $CONF_DIR/$CONF_FILE
    echo "addnode=52.14.225.17" >> $CONF_DIR/$CONF_FILE
    echo "addnode=3.16.29.195" >> $CONF_DIR/$CONF_FILE
    echo "addnode=18.220.105.129" >> $CONF_DIR/$CONF_FILE
    echo "addnode=18.224.183.32" >> $CONF_DIR/$CONF_FILE
    echo "addnode=18.218.246.251" >> $CONF_DIR/$CONF_FILE
    echo "addnode=95.179.139.68" >> $CONF_DIR/$CONF_FILE
    echo "addnode=3.16.10.163" >> $CONF_DIR/$CONF_FILE
    echo "addnode=18.188.164.171" >> $CONF_DIR/$CONF_FILE
    echo "addnode=3.16.125.132" >> $CONF_DIR/$CONF_FILE


  sudo ufw allow $PORT/tcp

  mv ${NAME}.conf_TEMP $CONF_DIR/${NAME}.conf
  cp apr_peers.dat $CONF_DIR/peers.dat
  
  sh ~/bin/${NAME}d_$ALIAS.sh
done
