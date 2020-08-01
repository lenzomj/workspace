#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source "${SCRIPT_DIR}/exec.sh"

parse_line () {
  local _line=$(eval echo $1)
  local _args="${_line##*:}"
  local _exec=""

  # comment
  if [[ ${_line} == \#* ]]; then
    : # noop
  # dir:
  elif [[ ${_line} == dir\:* ]]; then
    exec_mkdir "${_args}"
  # with:
  elif [[ ${_line} == with\:* ]]; then
    exec_mkdir "${_args}"
    _exec="${_args}"
  # end
  elif [[ ${_line} == end ]]; then
    _exec="popd"
  # get
  elif [[ ${_line} == get\:* ]]; then
    file_remote=${_line#*:}
    file_local=${_line##*/}
    echo "Downloading $file_remote ..." >&2
    exec_curl -# -L "${file_remote}" -o "${file_local}"
  # git
  elif [[ ${_line} == git\:* ]]; then
    repo_remote=${_line#*:}
    repo_local=${_line##*/}
    if [[ ! -d $repo_local ]]; then
      echo "Mirroring $repo_remote ..." >&2
      exec_git clone --mirror $repo_remote $repo_local
    else
      pushd $repo_local &> /dev/null;
        echo "Updating $repo_local ..." >&2
        exec_git remote update
      popd &> /dev/null;
    fi
  # github
  elif [[ ${_line} == github\:* ]]; then
    repo_remote="https://github.com/${_line#*:}"
    repo_local=${_line#*:}
    if [[ ! -d $repo_local ]]; then
      echo "Mirroring $repo_remote ..." >&2
      exec_git clone --mirror $repo_remote $repo_local
    else
      pushd $repo_local &> /dev/null;
        echo "Updating $repo_local ..." >&2
        exec_git remote update
      popd &> /dev/null;
    fi
  # brew
  elif [[ ${_line} == brew\:* ]]; then
    formula=${_line#*:}
    echo "Fetching ${formula} ..." >&2
    exec_brew fetch --deps ${formula}
  # install
  elif [[ ${_line} == install\:* ]]; then
    formula=${_line#*:}
    echo "Installing ${formula} ..." >&2
    exec_brew install ${formula} >&2
  # rsync
  elif [[ ${_line} == rsync:* ]]; then
    repo_remote="${_line#*:}"
    echo "Syncing ${repo_remote} ..." >&2
    exec_rsync -avSHP --delete ${repo_remote} >&2
  fi
  echo "${_exec}"
}

parse_block () {
  local _block=("$@")
  local _init_exec="$(pwd)"
  local _exec=""
  for _line in "${_block[@]}"; do
    _exec=$(parse_line "${_line}")
    if [[ "${_exec}" == "popd" ]]; then
      popd &> /dev/null;
    elif [[ -d "${_exec}" ]]; then
      pushd "${_exec}" &> /dev/null;
    fi
  done
  [[ "${_init_exec}" == "$(pwd)" ]] || (echo "error" && exit 1)
}

parse_file () {
  args=()

  if [[ -f $1 ]]; then
    while read line
    do
      args+=("$line")
    done < $1
  fi

  parse_block "${args[@]}"
}
