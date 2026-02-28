#!/bin/bash

CONFIG_FILE="logs/language.conf"
mkdir -p logs

language="en"

loadAllTranslations() {
    local lang="$1"
    local translations

    # Verifica se LANG_PATH é uma URL ou um arquivo local
    if [[ "$LANG_PATH" =~ ^https?:// ]]; then
        translations=$(curl -sSL "$LANG_PATH")
    else
        translations=$(cat "$LANG_PATH" 2>/dev/null)
    fi

    # Processa as traduções
    while IFS='=' read -r key value; do
        if [[ -n "$key" && "$key" == "$lang"* ]]; then
            local clean_key="${key#"$lang."}"
            # Remove aspas se existirem
            value="${value//\'/}"
            value="${value//\"/}"
            export "$clean_key"="$value"
        fi
    done <<< "$translations"
}

selectLanguage() {
    if [[ -f "/tmp/fmt.sh" ]]; then
        source "/tmp/fmt.sh"
    else
        curl -sSL "https://raw.githubusercontent.com/Ashu11-A/Ashu_eggs/main/Utils/fmt.sh" -o /tmp/fmt.sh
        source "/tmp/fmt.sh"
    fi

    # Definição de cores para uso no print_status_row (serão interpretadas por %b)
    local C_GRN="\033[1;32m"
    local C_RST="\033[0m"

    echo ""
    print_status_header " 🌐 " "Language Selection / Seleção de Idioma"
    
    print_status_row "${C_GRN}1${C_RST}" "English (Default)"
    print_status_row "${C_GRN}2${C_RST}" "Português (Brasil)"
    
    print_status_footer
    
    echo -en " \033[1;37m👉 Choice / Escolha (1-2): \033[0m"
    read -r choice

    case $choice in
        2)
            language="pt"
            echo "pt" > "$CONFIG_FILE"
            ;;
        1|*)
            language="en"
            echo "en" > "$CONFIG_FILE"
            ;;
    esac
}

# Carrega do arquivo se existir
if [[ -f "$CONFIG_FILE" ]]; then
    language=$(cat "$CONFIG_FILE")
elif [[ ! "${PWD}" == "/mnt/server" ]]; then
    selectLanguage
fi

# Carregar todas as traduções para o idioma selecionado
loadAllTranslations "$language"
