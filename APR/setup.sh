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
  sudo apt-get update && sudo apt-get install libzmq-5* -y

  cd /var
  sudo touch swap.img
  sudo chmod 600 swap.img
  sudo dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
  sudo mkswap /var/swap.img
  sudo swapon /var/swap.img
  sudo free
  sudo echo "/var/swap.img none swap sw 0 0" >> /etc/fstab
  cd

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

## COMPILE AND INSTALL
wget https://github.com/APRCoin/zenith-repository/releases/download/V3.0/aprcoin-v3.0.0-linux.zip
unzip aprcoin-v3.0.0-linux.zip
sudo chmod 755 Ubuntu/aprcoin*
sudo mv Ubuntu/aprcoin* /usr/bin
sudo mv aprcoin* /usr/bin

CONF_DIR=~/.aprcoin/
mkdir $CONF_DIR
CONF_FILE=aprcoin.conf
PORT=3134

wget https://github.com/XeZZoR/scripts/raw/master/APR/peers.dat -O $CONF_DIR/peers.dat

IP=$(curl -s4 icanhazip.com)

echo ""
echo "Enter masternode private key for node $ALIAS"
read PRIVKEY

echo "rpcuser=user"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcpassword=pass"`shuf -i 100000-10000000 -n 1` >> $CONF_DIR/$CONF_FILE
echo "rpcallowip=127.0.0.1" >> $CONF_DIR/$CONF_FILE
echo "listen=1" >> $CONF_DIR/$CONF_FILE
echo "server=1" >> $CONF_DIR/$CONF_FILE
echo "daemon=1" >> $CONF_DIR/$CONF_FILE
echo "logtimestamps=1" >> $CONF_DIR/$CONF_FILE
echo "maxconnections=16" >> $CONF_DIR/$CONF_FILE
echo "masternode=1" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE
echo "" >> $CONF_DIR/$CONF_FILE
echo "port=$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeaddr=$IP:$PORT" >> $CONF_DIR/$CONF_FILE
echo "masternodeprivkey=$PRIVKEY" >> $CONF_DIR/$CONF_FILE

echo "addnode=142.93.142.33" >> $CONF_DIR/$CONF_FILE
echo "addnode=206.189.160.179" >> $CONF_DIR/$CONF_FILE
echo "addnode=178.128.166.102" >> $CONF_DIR/$CONF_FILE
echo "addnode=167.99.171.144" >> $CONF_DIR/$CONF_FILE
echo "addnode=209.97.183.237" >> $CONF_DIR/$CONF_FILE
echo "addnode=104.248.244.144" >> $CONF_DIR/$CONF_FILE
echo "addnode=159.89.207.84" >> $CONF_DIR/$CONF_FILE
echo "addnode=80.85.158.36" >> $CONF_DIR/$CONF_FILE
echo "addnode=91.211.248.160" >> $CONF_DIR/$CONF_FILE
echo "addnode=164.132.135.102" >> $CONF_DIR/$CONF_FILE
echo "addnode=185.235.131.132" >> $CONF_DIR/$CONF_FILE
echo "addnode=178.159.38.187" >> $CONF_DIR/$CONF_FILE
sudo ufw allow $PORT/tcp



aprcoind -daemon
