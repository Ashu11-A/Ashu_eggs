#!/bin/bash

echo "⚙️  Versão do Script: 1.3"
echo "✅ Iniciando tModLoader"
dotnet tModLoader.dll -server "$@" -config serverconfig.txt
