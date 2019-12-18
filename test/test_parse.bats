#!/usr/bin/env bats

load test_helper.bash
load "${BATS_TEST_DIRNAME}/../scripts/parse.sh"

@test "parse_line '# comment' does nothing" {
  run parse_line "# This is a comment"
  [ "${status}" -eq 0 ]
  [[ "${output}" == "" ]]
}

@test "parse_line 'dir:aDir/aDir' creates relative path directory" {
  cd "${BATS_TEST_TMPDIR}" && run parse_line "dir:aDir/aDir"
  [ "${status}" -eq 0 ]
  [[ "${output}" == "" ]]
  [[ -d "${BATS_TEST_TMPDIR}/aDir/aDir" ]]
}

@test "parse_line 'dir:\$var/bDir/bDir' expands variable path directory" {
  run parse_line "dir:\${BATS_TEST_TMPDIR}/bDir/bDir"
  [ "${status}" -eq 0 ]
  [[ "${output}" == "" ]]
  [[ -d "${BATS_TEST_TMPDIR}/bDir/bDir" ]]
}

@test "parse_line '  dir:cDir/cDir' ignores leading whitespace" {
  cd "${BATS_TEST_TMPDIR}" && run parse_line "  dir:cDir/cDir"
  [ "${status}" -eq 0 ]
  [[ "${output}" == "" ]]
  [[ -d "${BATS_TEST_TMPDIR}/cDir/cDir" ]]
}

@test "parse_line 'with:\$var/dDir/dDir' returns new execution context" {
  run parse_line "with:\${BATS_TEST_TMPDIR}/dDir/dDir"
  [ "${status}" -eq 0 ]
  [[ "${output}" == "${BATS_TEST_TMPDIR}/dDir/dDir" ]]
  [[ -d "${BATS_TEST_TMPDIR}/dDir/dDir" ]]
}

@test "parse_line 'end' terminates execution context" {
  run parse_line "end"
  [ "${status}" -eq 0 ]
  [[ "${output}" == "popd" ]]
}

@test "parse_block 'with..end' changes execution context" {
  block=()
  block+=("with:\${BATS_TEST_TMPDIR}/eDir/eDir")
  block+=("  dir:eDir/eDir")
  block+=("end")
  run parse_block "${block[@]}"
  [ "${status}" -eq 0 ]
  [[ -d "${BATS_TEST_TMPDIR}/eDir/eDir/eDir/eDir" ]]
}

@test "parse_block 'with..with..end..end' changes nested execution context" {
  block=()
  block+=("with:\${BATS_TEST_TMPDIR}/fDir/fDir")
  block+=("  with:fDir")
  block+=("    dir:fDir/fDir")
  block+=("  end")
  block+=("end")
  run parse_block "${block[@]}"
  [ "${status}" -eq 0 ]
  [[ -d "${BATS_TEST_TMPDIR}/fDir/fDir/fDir/fDir/fDir" ]]
}

@test "parse_block 'with..' raises error" {
  block=()
  block+=("with:\${BATS_TEST_TMPDIR}/fDir/fDir")
  run parse_block "${block[@]}"
  [ "${status}" -eq 1 ]
}
