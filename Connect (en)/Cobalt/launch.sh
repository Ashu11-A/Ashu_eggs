#!/bin/bash
if [ "${SERVER_IP}" = "0.0.0.0" ]; then
    MGM="on port ${SERVER_PORT}"
else
    MGM="on ${SERVER_IP}:${SERVER_PORT}"
fi
echo "🟢 Web interface starting ${MGM}..."
npm start
