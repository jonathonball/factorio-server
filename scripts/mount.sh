#!/bin/bash

NVME_LOG_FILE=${ log_path };
EPHEMERAL_NAME=${ volume_ephemeral_name };
EPHEMERAL_PATH=/dev/$${EPHEMERAL_NAME};
MOUNT_POINT=${ mountpoint };
BLOCK_DEVICE=;

function write_log() {
  echo "[$(date)] $${1}" >> $NVME_LOG_FILE;
};

function ephemeral_link_missing() {
  if [ -h /dev/$1 ]; then
    write_log "Ephemeral link $${1} exists";
    return 1;
  fi;
  write_log "Ephemeral link $${1} is missing";
  return 0;
};

function create_ephemeral_link() {
  write_log "Creating $${2} -> $${1}";
  ln -s $1 $2;
}

function mountpoint_missing() {
  if [ -d $1 ]; then
    write_log "Mountpoint $${1} exists";
    return 1;
  fi;
  write_log "Mountpoint $${1} is missing";
  return 0;
};

function create_mountpoint() {
  write_log "Creating mountpoint: $${1}";
  mkdir -p $1;
  chown 0777 $1;
};

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

function format_block_device_ext4() {
  write_log "Formatting $${1} as ext4";
  mkfs.ext4 $1;
};

##
# Program flow
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

# UUID=$(blkid --match-tag UUID --output export $EPHEMERAL_PATH | tail -1);
# write_log "Found UUID for $${EPHEMERAL_PATH}: $${UUID}";
# write_log "Checking /etc/fstab for $UUID";
# eval $(echo $UUID)
# if ! grep $UUID /etc/fstab; then
#   FSTAB_LINE=$(echo -e "$${UUID}\t$${MOUNT_POINT}\text4\tdefaults,noatime,rw,user,umask=000\t0\t0");
#   write_log "Writing next line to fstab:";
#   write_log "$${FSTAB_LINE}";
#   echo "$${FSTAB_LINE}" >> /etc/fstab;
# fi;
