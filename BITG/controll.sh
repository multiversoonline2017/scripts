#!/bin/bash
NAME=bitcoingreen

if [[ $1 =~ "stop" ]] ; then
  for filename in bin/${NAME}-cli_*.sh; do
    sh $filename stop
  done
fi

if [[ $1 =~ "status" ]] ; then
  for filename in bin/${NAME}-cli_*.sh; do
    sh $filename masternode status
  done
fi

if [[ $1 =~ "start" ]] ; then
  for filename in bin/${NAME}d_*.sh; do
    sh $filename $2
  done
fi

if [[ $1 =~ "greper" ]] ; then
  for filename in bin/${NAME}-cli_*.sh; do
    sh $filename getinfo |grep $2
  done
fi