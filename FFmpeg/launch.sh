#!/bin/bash
echo "🟢  Iniciando servidor..."
npm ci 
npm test
npm run build
