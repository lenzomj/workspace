#!/usr/bin/env bash

dd if=/dev/zero of=/EMPTY bs=1M | true # Ignore errors on full
rm -f /EMPTY

sync # Block until empty
