#!/usr/bin/env bash
# Run this script on App-A after peering and route/security configuration.
# Expected outcome: four replies from App-B. The script reports the command result;
# it does not create AWS resources or manufacture evidence.

set -u
TARGET="${1:-10.20.1.10}"

echo "Host: $(hostname)"
echo "Local addresses: $(hostname -I)"
echo "Testing private peer: ${TARGET}"
ping -c 4 "${TARGET}"
status=$?

if [ "$status" -eq 0 ]; then
  echo "RESULT: ping command succeeded"
else
  echo "RESULT: ping command failed (inspect routes, peering and ICMP rules)"
fi
exit "$status"
