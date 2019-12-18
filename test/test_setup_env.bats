#!/usr/bin/env bats

load test_helper.bash
load "${BATS_TEST_DIRNAME}/../scripts/setup.sh"

setup () {
  export home_dir="${BATS_TEST_TMPDIR}"
  export workspace_dir="${home_dir}/some/path/to/my/workspace"
  export workspace_conf="${home_dir}/.workspace.conf"
  run setup_env "${workspace_dir}" "${home_dir}"
  [ "${status}" -eq 0 ]
}

@test "setup_env() generates .workspace.conf" {
  [[ -f "${workspace_conf}" ]]
}

@test "setup_env() exports WORKSPACE_* variables" {
  source "${workspace_conf}"
  [[ "${WORKSPACE}" = "${workspace_dir}" ]]
  [[ "${WORKSPACE_DOTFILES}" == "${workspace_dir}/dotfiles" ]]
  [[ "${WORKSPACE_SCRIPTS}"  == "${workspace_dir}/scripts" ]]
  [[ "${WORKSPACE_FONTS}"    == "${workspace_dir}/fonts" ]]
  [[ "${WORKSPACE_MANIFEST}" == "${workspace_dir}/manifest" ]]
  [[ "${WORKSPACE_MIRROR}"   == "${workspace_dir}/mirror" ]]
  [[ "${WORKSPACE_USER}"     == "${home_dir}" ]]
}
