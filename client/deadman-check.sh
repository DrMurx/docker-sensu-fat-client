#!/bin/bash

name="$1"
status="$2"
ttl="$3"

shift 3
text="$@"

nc localhost 3030 <<EOF
{
  "name": "$name",
  "ttl": $ttl,
  "status": $status,
  "output": "$text"
}
EOF
