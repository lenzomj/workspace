#!/usr/bin/env bash

exec_mkdir() {
  [[ -d "$1" ]] || mkdir -p "$1"
}

exec_git() {
  [[ -x "$(command -v git)" ]] && (git "${@}") &> /dev/null;
}

exec_curl() {
  [[ -x "$(command -v curl)" ]] && (curl "${@}");
}

exec_rsync() {
  [[ -x "$(command -v rsync)" ]] && (rsync "${@}");
}

safe_pip3() {
  [[ -x "$(command -v pip3)" ]] && (pip3 --disable-pip-version-check "${@}");
}

sync() {
  local _src=$1
  local _dst=$2
  echo "Syncing ${_src} -> ${_dst}"
  [[ -d ${_dst} ]] || mkdir -p ${_dst} &> /dev/null
  [[ -d ${_src} ]] && \
    safe_rsync --update --delete --progress -r ${_src}/ ${_dst}
}
