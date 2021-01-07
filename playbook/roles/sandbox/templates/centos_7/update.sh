#!/usr/bin/env bash

HAS_INTERNET=true
# -- {% if not box_has_internet %}
HAS_INTERNET=false
# -- {% endif %}

# Use host mirror for standalone builds
if [[ ! $HAS_INTERNET ]]; then
  sudo cat > "/etc/yum.repos.d/CentOS-HostMirror.repo" << _EOS
[mirror-host]
name=CentOS-\$releasever - Bootstrap Mirror
baseurl=http://10.0.2.2:{{ box_netmirror_port }}/mirror.centos.org/centos/\$releasever/os/\$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
gpgcheck=1
enabled=1
_EOS
  sudo yum --disablerepo=* --enablerepo=mirror-host update -y
  sudo yum --disablerepo=* --enablerepo=mirror-host install -y gcc perl kernel-headers kernel-devel
  sudo rm "/etc/yum.repos.d/CentOS-HostMirror.repo"
else
  sudo yum update -y
  sudo yum install -y gcc perl kernel-headers kernel-devel
fi

if [[ ! -d "/usr/src/kernels/$(uname -r)" ]]; then
  echo "Rebooting VM after kernel update ..."
  sudo reboot
fi
