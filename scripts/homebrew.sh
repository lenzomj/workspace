#!/usr/bin/env bash

setup_homebrew() {
  export HOMEBREW_PREFIX="${WORKSPACE}/homebrew"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_CACHE="${WORKSPACE_MIRROR}/homebrew"
  export HOMEBREW_TAP="${HOMEBREW_PREFIX}/Library/Taps/homebrew/homebrew-core"

  export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin${PATH+:$PATH}"
  export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH}"

  if [ ! -d "${HOMEBREW_REPOSITORY}" ]; then
    git clone "${WORKSPACE_MIRROR}/github/homebrew/brew.git" \
      "${HOMEBREW_REPOSITORY}"
  fi

  if [ ! -d "${HOMEBREW_TAP}" ]; then
    git clone "${WORKSPACE_MIRROR}/github/lenzomj/linuxbrew-lite.git" \
      "${HOMEBREW_TAP}"
    pushd "${HOMEBREW_TAP}" &> /dev/null;
      git remote add upstream "git@github.com:lenzomj/linuxbrew-lite.git"
    popd &> /dev/null;
  fi
}

clean_homebrew() {
  rm -rf "${HOMEBREW_REPOSITORY}"

  unset HOMREBREW_PREFIX
  unset HOMREBREW_REPOSITORY
  unset HOMEBREW_CELLAR
  unset HOMEBREW_CACHE
  unset HOMEBRE_TAP

  # TODO: Restore these ...
  # PATH
  # MANPATH
  # INFOPATH
}
