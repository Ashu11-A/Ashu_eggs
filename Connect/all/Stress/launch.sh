#!/bin/bash

CPU_CORES=${CPU_CORES:-1}
MEMORY=${MEMORY:-512}
METRICS=${METRICS:-0}
CPU=${CPU:-0}
CPU_MEMORY=${CPU_MEMORY:-0}
TIMEOUT=${TIMEOUT:-0}
CONSOLE=${CONSOLE:-0}

declare -a params=()

if [ "${CONSOLE}" = "1" ]; then
    # shellcheck disable=SC2206
    params=(${CONSOLE_OCC})
else
    if [ "${CPU}" = "1" ]; then
        params+=(--cpu "${CPU_CORES}")
    fi

    if [ "${CPU_MEMORY}" = "1" ]; then
        params+=(--vm "${CPU_CORES}" --vm-bytes "${MEMORY}M")
    fi

    if [ "${METRICS}" = "1" ]; then
        params+=(--metrics-brief)
    fi

    if [ -n "${TIMEOUT}" ] && [ "${TIMEOUT}" != "0" ]; then
        params+=(--timeout "${TIMEOUT}s")
    fi
fi

printf "${script_version}\n" "1.2"
printf "${executing}\n" "stress-ng ${params[*]}"

stress-ng "${params[@]}"
