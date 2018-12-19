#!/bin/bash


echo "ONLY USE THIS SCRIPT IF YOU USED THE NORMAL 'setup.sh' script - IF YOU USED THE 'setup_multi.sh' USE THE APPRECIATE UPDATE SCRIPT"
echo "BEFORE YOU PROCEED MAKE SURE YOUR GUI WALLET (WIN/MAC) IS UPDATED ALREADY!"
echo "Enter 1 to update, enter 2 to check status (Press enter after) ONLY UPDATE ONCE!!!!!"
read UPDATE

if [[ $UPDATE =~ "1" ]] ; then
    echo "This will stop update your node! Type yes to proceed"
    read OK
    if [[ $OK =~ "yes" ]]; then

      aprcoin-cli stop

      ## COMPILE AND INSTALL
      https://github.com/APRCoin/zenith-repository/releases/download/V3.0/aprcoin-v3.0.0-linux.zip
      unzip aprcoin-v3.0.0-linux.zip
      sudo chmod 755 Ubuntu/aprcoin*
      sudo mv Ubuntu/aprcoin* /usr/bin
      sudo mv aprcoin* /usr/bin

      sudo apt-get update && sudo apt-get install libzmq-5* -y

      rm -r  .aprcoin/b* .aprcoin/a* .aprcoin/c* .aprcoin/d* .aprcoin/p* .aprcoin/m* .aprcoin/f*
      echo "addnode=45.77.227.93" >> .aprcoin/aprcoin.conf
      echo "addnode=18.191.175.138" >> .aprcoin/aprcoin.conf
      echo "addnode=18.188.93.12" >> .aprcoin/aprcoin.conf
      echo "addnode=85.214.199.57" >> .aprcoin/aprcoin.conf
      echo "addnode=18.222.190.189" >> .aprcoin/aprcoin.conf
      echo "addnode=3.16.148.30" >> .aprcoin/aprcoin.conf
      echo "addnode=209.97.183.127" >> .aprcoin/aprcoin.conf
      echo "addnode=3.16.166.214" >> .aprcoin/aprcoin.conf
      echo "addnode=108.61.175.177" >> .aprcoin/aprcoin.conf
      echo "addnode=142.93.32.206" >> .aprcoin/aprcoin.conf
      echo "addnode=178.128.166.102" >> .aprcoin/aprcoin.conf
      echo "addnode=140.82.29.242" >> .aprcoin/aprcoin.conf
      echo "addnode=104.156.232.221" >> .aprcoin/aprcoin.conf
      echo "addnode=167.99.160.210" >> .aprcoin/aprcoin.conf
      echo "addnode=52.14.225.17" >> .aprcoin/aprcoin.conf
      echo "addnode=3.16.29.195" >> .aprcoin/aprcoin.conf
      echo "addnode=18.220.105.129" >> .aprcoin/aprcoin.conf
      echo "addnode=18.224.183.32" >> .aprcoin/aprcoin.conf
      echo "addnode=18.218.246.251" >> .aprcoin/aprcoin.conf
      echo "addnode=95.179.139.68" >> .aprcoin/aprcoin.conf
      echo "addnode=3.16.10.163" >> .aprcoin/aprcoin.conf
      echo "addnode=18.188.164.171" >> .aprcoin/aprcoin.conf
      echo "addnode=3.16.125.132" >> .aprcoin/aprcoin.conf

      echo "Wait for shutdowns..."
      sleep 60

      aprcoind -resync

      echo "Wait for blockchain to restart... (ca 3 mins)"

      sleep 180

      aprcoin-cli masternode status
      echo "Your nodes have been updated and restarted. Please wait 20 minutes and check the status if not active already!"
    else
      echo "SCRIPT WAS BROKEN BECAUSE YOU DID NOT READ OR TYPED yes ! Start again and follow instructions"
    fi
else
    aprcoin-cli masternode status
fi