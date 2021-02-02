#!/usr/bin/env bash

REPO=$1
DEST=$2

if [[ ! -d "${DEST}" ]]; then
  git clone --mirror --recursive "${REPO}" "${DEST}"
else
  pushd "${DEST}" &> /dev/null;
    git remote update
  popd &> /dev/null;
fi
