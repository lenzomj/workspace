#!/usr/bin/env bats

load test_helper.bash

@test "setup_file exports BATS_TEST_TESTNAME" {
  [[ "${BATS_TEST_TESTNAME}" == "test_harness" ]]
}

@test "setup_file creates BATS_TEST_TMPDIR" {
  [[ -d "${BATS_TEST_TMPDIR}" ]]
}

@test "set_teardown_noclean within test has no effect" {
  set_teardown_noclean
  [[ ${BATS_TEST_TMPDIR_CLEAN} == false ]]
}

@test "set_teardown_noclean is initially unset" {
  [[ -z ${BATS_TEST_TMPDIR_CLEAN} ]]
}

@test "create_git_repo creates cloneable repository" {
  run create_git_repo "${BATS_TEST_TMPDIR}/repo.git"
  [ "${status}" -eq 0 ]
  git clone "${BATS_TEST_TMPDIR}/repo.git" "${BATS_TEST_TMPDIR}/repo"
  [[ -f "${BATS_TEST_TMPDIR}/repo/README.md" ]]
}

