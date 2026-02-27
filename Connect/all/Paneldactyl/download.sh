#!/bin/bash

# 1. Identificação da Fonte (Release ou Git)
if [[ -z "${PANEL}" ]]; then
  github_repo_slug="Next-Panel/Jexactyl-BR"
  panel_file_target="panel.tar.gz"
else
  case "${PANEL}" in
    "Pterodactyl")
      github_repo_slug="pterodactyl/panel"
      panel_file_target="panel.tar.gz"
      ;;
    "Jexactyl")
      github_repo_slug="Jexactyl/Jexactyl"
      panel_file_target="panel.tar.gz"
      ;;
    "Jexactyl Brasil")
      github_repo_slug="Next-Panel/Jexactyl-BR"
      panel_file_target="panel.tar.gz"
      ;;
    "Pterodactyl Brasil")
      github_repo_slug="Next-Panel/Pterodactyl-BR"
      panel_file_target="panel.tar.gz"
      ;;
    *)
      github_repo_slug="Next-Panel/Jexactyl-BR"
      panel_file_target="panel.tar.gz"
      ;;
  esac
fi

if [[ -n "${GIT_ADDRESS}" ]]; then
  export DOWNLOAD_SOURCE="git"
  export DOWNLOAD_LINK="${GIT_ADDRESS}"
  export CLEAN_VERSION="${BRANCH:-main}"
else
  export DOWNLOAD_SOURCE="release"
  
  # Busca informações da release via API do GitHub
  if [[ -z "${VERSION}" ]] || [[ "${VERSION}" == "latest" ]]; then
    latest_release_json=$(curl --silent "https://api.github.com/repos/${github_repo_slug}/releases" | jq -c '.[]' | head -1)
    export DOWNLOAD_LINK=$(echo "${latest_release_json}" | jq .assets | jq -r .[].browser_download_url | grep -i "${panel_file_target}")
    export CLEAN_VERSION=$(echo "${latest_release_json}" | jq -r .tag_name)
  else
    all_releases_json=$(curl --silent "https://api.github.com/repos/${github_repo_slug}/releases" | jq '.[]')
    version_match=$(echo "${all_releases_json}" | jq -r --arg VERSION "${VERSION}" '. | select(.tag_name==$VERSION) | .tag_name')
    
    if [[ "${VERSION}" == "${version_match}" ]]; then
      export DOWNLOAD_LINK=$(echo "${all_releases_json}" | jq -r --arg VERSION "${VERSION}" '. | select(.tag_name==$VERSION) | .assets[].browser_download_url' | grep -i "${panel_file_target}")
      export CLEAN_VERSION="${VERSION}"
    else
      # Fallback para latest se a versão não for encontrada
      latest_release_json=$(curl --silent "https://api.github.com/repos/${github_repo_slug}/releases" | jq -c '.[]' | head -1)
      export DOWNLOAD_LINK=$(echo "${latest_release_json}" | jq .assets | jq -r .[].browser_download_url | grep -i "${panel_file_target}")
      export CLEAN_VERSION=$(echo "${latest_release_json}" | jq -r .tag_name)
    fi
  fi
  
  export FILE_NAME="${DOWNLOAD_LINK##*/}"
fi

# 2. Gerenciamento de Node.js e NVM
if [[ -f /etc/os-release ]]; then
  distribution_id=$(grep ^ID= /etc/os-release | cut -d'=' -f2 | tr -d '"')
  
  if [[ "${distribution_id}" == "alpine" ]]; then
    echo "${alpine_warning}"
  elif [[ "${distribution_id}" == "debian" ]]; then
    # Gerenciamento de Node.js e NVM
    export NVM_DIR="${NVM_DIR:-/home/container/.nvm}"
    curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/nvm.sh" -o /tmp/nvm.sh && bash /tmp/nvm.sh

    # shellcheck source=/dev/null
    source "${NVM_DIR}/nvm.sh"
    node_version_target=$(cat logs/nodejs_version 2>/dev/null || echo "18")

    # Expõe o binário do Node.js
    export PATH="${PATH}:${NVM_DIR}/versions/node/v${node_version_target}/bin"
    
    echo -e "${yarn_install}"
    npm install --global yarn
  fi
fi

# 3. Processo de Instalação (Download ou Git)
if [[ "${DOWNLOAD_SOURCE}" == "git" ]]; then
  echo -e "\n \n${using_github_repo}"
  git_repo_url="${DOWNLOAD_LINK}"
  
  if [[ -n "${USERNAME}" ]] && [[ -n "${ACCESS_TOKEN}" ]]; then
    clean_url=$(echo "${git_repo_url}" | cut -d/ -f3-)
    git_repo_url="https://${USERNAME}:${ACCESS_TOKEN}@${clean_url}"
  fi
  
  if [[ -d "/home/container/panel" ]]; then
    (
      cd "panel" || exit 1
      if [[ -d ".git" ]]; then
        git pull --quiet
        fakeroot chmod -R 755 storage/* bootstrap/cache/
      fi
    )
  else
    if [[ -z "${BRANCH}" ]]; then
      git clone --quiet "${git_repo_url}" "./panel"
    else
      git clone --quiet --single-branch --branch "${BRANCH}" "${git_repo_url}" "./panel"
    fi
    fakeroot chmod -R 755 "/home/container/panel/storage/"* "/home/container/panel/bootstrap/cache/"*
    touch "./panel/panel_github_installed"
  fi
else
  # Instalação via Tarball de Release
  if [[ -d "/home/container/panel" ]]; then
    printf "\n \n${check_install}\n \n"
    print_status_header "${task_column}" "${status_column}"
    print_status_row "Panel" "${panel_installed}"
  else
    mkdir -p logs
    cat <<EOF > "./logs/log_install.txt"
Version: ${CLEAN_VERSION}
Link: ${DOWNLOAD_LINK}
EOF
    printf "\n \n${check_install}\n \n"
    print_status_header "${task_column}" "${status_column}"
    print_status_row "Panel" "${panel_downloading}"

    curl -sSL "${DOWNLOAD_LINK}" -o "${FILE_NAME}"
    mkdir -p "panel"
    mv "${FILE_NAME}" "panel/"
    (
      cd "panel" || exit 1
      echo -e "${unpacking}"
      tar -xvzf "${FILE_NAME}"
      rm -f "${FILE_NAME}"
      fakeroot chmod -R 755 storage/* bootstrap/cache/
    )
  fi
fi

# 4. Configuração de Nginx e PHP-FPM
if [[ ! -d "nginx" ]]; then
  git clone --quiet https://github.com/Ashu11-A/nginx ./temp_nginx
  cp -r ./temp_nginx/nginx ./
  rm -rf ./temp_nginx
  curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Connect/all/Paneldactyl/default.conf" -o ./nginx/conf.d/default.conf
  
  sed -i "s|root /home/container/panel/public|root /home/container/panel/public|g" nginx/conf.d/default.conf
  sed -i "s/listen.*/listen ${SERVER_PORT};/g" nginx/conf.d/default.conf
fi

if [[ ! -d "php-fpm" ]]; then
  git clone --quiet https://github.com/Ashu11-A/nginx ./temp_php
  cp -r ./temp_php/php-fpm ./
  cp -r ./temp_php/logs ./
  rm -rf ./temp_php
  echo "env[PATH] = /usr/local/bin:/usr/bin:/bin" >> php-fpm/php-fpm.conf
fi
