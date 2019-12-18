#!/usr/bin/env bash

setup_dotfiles() {
  export WORKSPACE_DOTFILES="${WORKSPACE}/dotfiles"

  if [ ! -d "${WORKSPACE_DOTFILES}" ]; then
    git clone "${WORKSPACE_MIRROR}/github/lenzomj/dotfiles.git" \
      "${WORKSPACE_DOTFILES}"
  fi
  "${WORKSPACE_DOTFILES}/install.sh" "${WORKSPACE_USER}"
}

clean_dotfiles() {
  if [ -d "${WORKSPACE_DOTFILES}" ]; then
    "${WORKSPACE_DOTFILES}/uninstall.sh" "${WORKSPACE_USER}"
    rm -rf "${WORKSPACE_DOTFILES}"
  fi

  unset WORKSPACE_DOTFILES
}
