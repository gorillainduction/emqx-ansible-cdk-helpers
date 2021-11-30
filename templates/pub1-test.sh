#!/bin/bash

# Publish to subjects that will send messages to the subscribers in sub1-test.sh

set -eu

LG_NUM=$1
OUTPUT_RECORDING=$2

TARGET="emqx-$(( $LG_NUM % {{ groups['emqx'] | length }} )).int.{{ emqx_cluster_name }}"
ipaddrs=$(ip addr | grep -o '192.*/32' | sed 's#/32##g' | paste -s -d , -)
ulimit -n 1000000

cd /root/emqtt-bench/

{
  env TZ={{ script_timezone }} date
  time ./emqtt_bench pub -c {{ emqtt_bench_number_of_connections }} -i {{ emqtt_bench_interval }} -x {{ emqtt_bench_session_expiry_interval }} -t 'bench/1/2/3/%c' -h $TARGET --ifaddr $ipaddrs 2>&1
} > "/tmp/$OUTPUT_RECORDING"
