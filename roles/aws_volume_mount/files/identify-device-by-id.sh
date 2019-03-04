#!/usr/bin/env bash

if [[ -z "$1" ]]; then
  echo "No volume id";
  exit 1;
fi;

for block_device in $(lsblk -l -p -o name -n); do
    volume_id=$(/sbin/ebsnvme-id --volume $block_device | awk '{ print $3 }');
    if [[ "$1" =~ "$volume_id" ]]; then
      echo $block_device;
      exit 0;
    fi;
done
