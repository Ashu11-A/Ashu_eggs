#!/bin/bash

echo "⚙️  Script version: 1.3"
echo "✅ Starting tModLoader"
dotnet tModLoader.dll -server "$@" -config serverconfig.txt
