#!/bin/bash

I=5; TS=0
[[ "$*" == *--ts* ]] && TS=1
[[ "$*" == *new* ]] && S=">" && T="[NEW]"
[[ "$*" == *old* ]] && S="<" && T="[OLD]"
[[ -z "$S" ]] && echo "Usage: $0 {new|old} [--ts]" && exit 1

O=/tmp/ns_old N=/tmp/ns_new L=/tmp/ns_log
touch "$L"

while :; do
		netstat -ap 2>/dev/null >"$O"
		sleep "$I"
		netstat -ap 2>/dev/null >"$N"

		diff "$O" "$N" | grep "^$S" | sed "s/^$S //" |
		while read -r l; do
				[[ $TS -eq 1 ]] && echo "$(date '+%F %T') $T $l" >>"$L" \
											 || echo "$T $l" >>"$L"
		done
done
