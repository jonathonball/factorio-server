#!/bin/bash
# This script will handle the initial formatting and mounting for an AWS EBS

NVME_LOG_FILE=${ log_path };
EPHEMERAL_NAME=${ volume_ephemeral_name };
EPHEMERAL_PATH=/dev/$${EPHEMERAL_NAME};
MOUNT_POINT=${ mountpoint };
BLOCK_DEVICE=;

##
# Writes a line a log
# $1 - string - the line to add to the log
##
function write_log() {
  echo "[$(date)] $${1}" >> $NVME_LOG_FILE;
};

##
# Check if there is a symlink that represent the ephemeral name of an
# AWS EBS volume.
# $1 - string - the ephemeral name without the full path. i.e. sdx
##
function ephemeral_link_missing() {
  if [ -h /dev/$1 ]; then
    write_log "Ephemeral link $${1} exists";
    return 1;
  fi;
  write_log "Ephemeral link $${1} is missing";
  return 0;
};

##
# Creates symlink mapping ephemeral name to nvme name
# Wrapper for 3rd form on ln
# $1 - path - symbolic link TARGET
# $2 - path - symbolic link DIRECTORY
##
function create_ephemeral_link() {
  write_log "Creating $${2} -> $${1}";
  ln -s $1 $2;
}

##
# Checks to see if a mountpoint path exists
# $1 - path - mountpoint
##
function mountpoint_missing() {
  if [ -d $1 ]; then
    write_log "Mountpoint $${1} exists";
    return 1;
  fi;
  write_log "Mountpoint $${1} is missing";
  return 0;
};

##
# Creates a mountpoint suitable for users
# $1 - path - mountpoint
##
function create_mountpoint() {
  write_log "Creating mountpoint: $${1}";
  mkdir -p $1;
  chown 0777 $1;
};

##
# Indentify which nvme goes with an emphemeral name
# $1 - string - ephemeral
##
function identify_block_device() {
  write_log "Beginning block_device identification for $${1}";
  for device in $(find /dev -regextype gnu-awk -regex '/dev/nvme[0-9]n[0-9]'); do
    device_map=$(/sbin/ebsnvme-id --block-dev $${device});
    device_map_basename=$(basename $${device_map});
    if [[ "$${device_map_basename}" == "$${1}" ]]; then
      write_log "Identified block device mapping: $${device_map_basename} -> $${device}";
      BLOCK_DEVICE=$${device};
      return 0;
    fi;
  done;
  write_log "Unable to identify block device with ephemeral name $${1}";
  exit 1;
};

##
# Check to see if there is an existing filesystem
# $1 - path - device to inspect
##
function device_requires_format() {
  write_log "Checking filesystem of $${1}";
  data_type=$(file --brief --dereference --special-files $1);
  if [[ "$${data_type}" == "data" ]]; then
    write_log "$${1} appears unformatted!";
    return 0;
  fi;
  write_log "$${1} appears to have a filesystem";
  return 1;
};

##
# Format a device as ext4
# $1 - path - device to format
##
function format_block_device_ext4() {
  write_log "Formatting $${1} as ext4";
  mkfs.ext4 $1;
};

##
# Script execution flow
##
if mountpoint_missing $MOUNT_POINT; then
  create_mountpoint $MOUNT_POINT;
fi;

if ephemeral_link_missing $EPHEMERAL_NAME; then
  identify_block_device $EPHEMERAL_NAME;
  create_ephemeral_link $BLOCK_DEVICE $EPHEMERAL_PATH;
fi;

if device_requires_format $EPHEMERAL_PATH; then
  format_block_device_ext4 $EPHEMERAL_PATH;
fi;

write_log "Attempting to mount $${EPHEMERAL_PATH} -> $${MOUNT_POINT}";
mount $EPHEMERAL_PATH $MOUNT_POINT;
