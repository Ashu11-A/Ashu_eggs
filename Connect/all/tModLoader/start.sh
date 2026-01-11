#!/bin/bash

echo "⚙️  Script version: 2.0"
echo "✅ Starting tModLoader"
dotnet tModLoader.dll -server "$@" -config serverconfig.txt
