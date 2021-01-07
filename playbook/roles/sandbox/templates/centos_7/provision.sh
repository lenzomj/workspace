#!/usr/bin/env bash

URI="http://download.virtualbox.org"
# -- {% if not box_has_internet %}
URI="http://10.0.2.2:{{ box_netmirror_port }}/download.virtualbox.org"
# -- {% endif %}

if [[ ! $(lsmod | grep -i vboxguest) ]]; then
  curl "${URI}/virtualbox/6.1.16/VBoxGuestAdditions_6.1.16.iso" -o VBoxGuestAdditions_6.1.16.iso
  sudo mkdir /media/VBoxGuestAdditions
  sudo mount -o loop,ro VBoxGuestAdditions_6.1.16.iso /media/VBoxGuestAdditions
  sudo sh /media/VBoxGuestAdditions/VBoxLinuxAdditions.run --nox11
  rm VBoxGuestAdditions_6.1.16.iso
  sudo umount /media/VBoxGuestAdditions
  sudo rmdir /media/VBoxGuestAdditions
else
  echo "Package VBoxGuestAdditions_6.1.16 already installed and latest version"
fi
