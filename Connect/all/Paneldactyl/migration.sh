#!/bin/bash

# (painel -> panel)
if [[ -d "/home/container/painel" ]]; then
  echo "${migrating_dir_painel_to_panel}"
  mv "/home/container/painel" "/home/container/panel"
fi

# (instalado -> installed)
if [[ -d "logs" ]]; then
  echo "${migrating_logs_instalado_to_installed}"
  for old_log in logs/*_instalado; do
    if [[ -f "${old_log}" ]]; then
      new_log="${old_log%_instalado}_installed"
      mv "${old_log}" "${new_log}"
    fi
  done
fi

if [[ -f "panel/panel_github_instalado" ]]; then
  echo "${migrating_github_marker}"
  mv "panel/panel_github_instalado" "panel/panel_github_installed"
fi

echo "${migration_completed}"
