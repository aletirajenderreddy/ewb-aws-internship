#!/usr/bin/env bash
# Run on the named EC2 host. These commands are evidence collection aids,
# not proof until executed and captured on the real instances.
set -euo pipefail
echo "HOST=$(hostname)"
echo "PRIVATE_IPS=$(hostname -I)"
case "${1:-}" in
  from-a) ping -c 4 10.20.1.10 ;;
  from-b) ping -c 4 10.10.2.10 ;;
  *) echo "Usage: $0 from-a|from-b"; exit 2 ;;
esac
