#!/bin/bash

set -eu

LG_NUM=$1
OUTPUT_RECORDING=$2

TARGET="emqx-$(( $LG_NUM % 2 )).int.thalesmg"
ipaddrs=$(ip addr | grep -o '192.*/32' | sed 's#/32##g' | paste -s -d , -)
ulimit -n 1000000

cd /root/emqtt-bench/

{
  env TZ=America/Sao_Paulo date
  time ./emqtt_bench sub -c 100000 -i 1 -t 'bench/1/2/3/#' -h $TARGET --ifaddr $ipaddrs 2>&1
} > "/tmp/$OUTPUT_RECORDING"
