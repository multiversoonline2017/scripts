#!/bin/bash


echo "ONLY USE THIS SCRIPT IF YOU USED THE MULTI 'setup_multi.sh' script - IF YOU USED THE NORMAL 'setup.sh' USE THE APPRECIATE UPDATE SCRIPT"
echo "BEFORE YOU PROCEED MAKE SURE YOUR GUI WALLET (WIN/MAC) IS UPDATED ALREADY!"
echo "Enter 1 to update, enter 2 to check status (Press enter after) ONLY UPDATE ONCE!!!!!"
read UPDATE

if [[ $UPDATE =~ "1" ]] ; then
    echo "You have to go to your GUI Wallet now and restart ALL nodes on it! before you continue! Type yes to proceed"
    read OK
    if [[ $OK =~ "yes" ]]; then

      sudo apt-get install libzmq-5* -y
      for filename in bin/aprcoin-cli_*.sh; do
        sh $filename stop
      done

      ## COMPILE AND INSTALL
      wget https://github.com/XeZZoR/scripts/raw/master/APR/aprcoin-cli
      wget https://github.com/XeZZoR/scripts/raw/master/APR/aprcoin-qt
      wget https://github.com/XeZZoR/scripts/raw/master/APR/aprcoin-tx
      wget https://github.com/XeZZoR/scripts/raw/master/APR/aprcoind
      sudo chmod 755 aprcoin*
      sudo mv aprcoin* /usr/bin

      rm .apr*/mn*

      echo "Wait for shutdowns..."
      sleep 60

      for filename in bin/aprcoind_*.sh; do
        sh $filename
      done
      echo "Wait for blockchain to restart... (ca 3 mins)"

      sleep 180

      for filename in bin/aprcoin-cli_*.sh; do
        sh $filename masternode status
      done
      echo "Your nodes have been updated and restarted. Please wait 5 minutes and check the status if not active already!"
    else
      echo "SCRIPT WAS BROKEN BECAUSE YOU DID NOT READ OR TYPED yes ! Start again and follow instructions"
    fi
else
  for filename in bin/aprcoin-cli_*.sh; do
    sh $filename masternode status
  done
fi
