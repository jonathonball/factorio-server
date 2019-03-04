aws volume mount
=========

Mounts a list of EBC volumes by their /dev/sdX designation useful for when on 
a machine that uses an nvme naming scheme.

Requirements
------------

None

Role Variables
--------------

A list `block_device_data`.

    block_device_data:
      - name: sdx
        mount_point: /some/point/in/fs
        filesystem: ext4

Dependencies
------------

None

Example Playbook
----------------

---
- name: Example
  hosts: all
  roles:
    - role: aws_volume_mount
      block_device_data:
        - name: sdx
          mount_point: /some/point/in/fs
          filesystem: ext4

License
-------

MIT

Author Information
------------------

Jonathon Ball [jonathon.ball@gmail.com]