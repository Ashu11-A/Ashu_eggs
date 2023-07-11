#!/bin/ash

MCS=$([ "${METRICS}" == "1" ] && echo "--metrics-brief" || echo "")
CPU_ON=$([ "${CPU}" == "1" ] && echo "--cpu ${CPU_CORES}" || echo "") 
CPU_RAM=$([ "${CPU_MEMORY}" == "1" ] && echo "--vm ${CPU_CORES} --vm-bytes ${MEMORY}M" || echo "")
TIME=$([ "${TIMEOUT}" == "0" ] && echo "" || echo "--timeout ${TIMEOUT}s")

echo "⚙️  Versão do Script: 1.2"

echo "✓ Atualizando o script..."
curl -o start.sh https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/pt-BR/Stress/start.sh

if [ "${CONSOLE}" == "1" ]; then
    echo "Executando: stress-ng ${CONSOLE_OCC}"
    stress-ng ${CONSOLE_OCC}
 else
    echo "Executando: stress-ng ${CPU_ON} ${CPU_RAM} ${MCS} ${TIME}"
    stress-ng ${CPU_ON} ${CPU_RAM} ${MCS} ${TIME}
fi