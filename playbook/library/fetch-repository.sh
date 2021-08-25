#!/usr/bin/env bash

REPO=$1
DEST=$2

if [[ ! -d "${DEST}" ]]; then
  git clone --mirror --depth=1 --quiet "${REPO}" "${DEST}"
else
  pushd "${DEST}" &> /dev/null;
    git fetch --depth=1 --prune --prune-tags --quiet
    #git remote update --prune
  popd &> /dev/null;
fi
