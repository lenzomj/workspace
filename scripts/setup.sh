#!/usr/bin/env bash

setup_env() {
  local _envdir="$1"
  local _outdir="$2"
  cat << EOF > "${_outdir}/.workspace.conf"

  export WORKSPACE="${_envdir}"
  export WORKSPACE_SCRIPTS="${_envdir}/scripts"
  export WORKSPACE_MANIFEST="${_envdir}/manifest"
  export WORKSPACE_MIRROR="${_envdir}/mirror"
  export WORKSPACE_USER="${_outdir}"

  alias workspace='\${WORKSPACE}/workspace'

  #
  # WORKSPACE_MODE
  #   ONLINE
  #   OFFLINE
  #
  export WORKSPACE_MODE=ONLINE

  #
  # WORKSPACE_OFFLINE_MIRROR
  #   The full path to your offline mirror
  #
  export WORKSPACE_OFFLINE_MIRROR=/media/does_not_exist
EOF
}

clean_env() {
  rm -rf "${WORKSPACE_USER}/.workspace.conf"
  unset WORKSPACE
  unset WORKSPACE_SCRIPTS
  unset WORKSPACE_MANIFEST
  unset WORKSPACE_MIRROR
  unset WORKSPACE_USER
  unset workspace
  unset WORKSPACE_MODE
  unset WORKSPACE_OFFLINE_MIRROR
}
