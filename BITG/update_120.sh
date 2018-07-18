#!/bin/bash

echo "Enter 1 to update, enter 2 to check status (Press enter after) ONLY UPDATE ONCE!!!!!"
read UPDATE

if [[ $UPDATE =~ "1" ]] ; then
  # update wallet
  wget https://github.com/bitcoingreen/bitcoingreen/releases/download/1.2.0/bitcoingreen-1.2.0-x86_64-linux-gnu.tar.gz
  tar -xzf bitcoingreen-1.2.0-x86_64-linux-gnu.tar.gz
  chmod 755 bitcoingreen-1.2.0/bin/*
  rm /usr/bin/bitcoingreen*
  mv bitcoingreen-1.2.0/bin/bitcoingreen* /usr/bin
  rm -r bitcoingreen-1.2.0

  for filename in bin/bitcoingreen-cli_*.sh; do
    sh $filename stop
  done

  sleep 30

  for filename in bin/bitcoingreend_*.sh; do
    sh $filename
  done
  echo "Wait for blockchain to restart...."

  sleep 60

  for filename in bin/bitcoingreen-cli_*.sh; do
    sh $filename masternode status
  done
  echo "Your nodes have been updated and restarted. Please wait 5 minutes and check the status if not active already!"

else
  for filename in bin/bitcoingreen-cli_*.sh; do
    sh $filename masternode status
  done
fi