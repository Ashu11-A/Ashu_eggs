#!/bin/bash

CONFIG_FILE="logs/language.conf"

mkdir -p logs

# Função para carregar todas as traduções de um idioma
loadAllTranslations() {
    local lang="$1"

    # Verifica se LANG_PATH é uma URL ou um arquivo local
    if [[ "$LANG_PATH" =~ ^https?:// ]]; then
        # Carrega o conteúdo da URL
        translations=$(curl -s "$LANG_PATH")
    else
        # Lê o arquivo de tradução local
        translations=$(< "$LANG_PATH")
    fi

    # Processa as traduções
    while IFS='=' read -r key value; do
        # Verifica se a chave não está vazia
        if [[ -n "$key" ]]; then
            # Verifica se a chave começa com o prefixo do idioma
            if [[ "$key" == "$lang"* ]]; then
                # Remove o prefixo do idioma da chave
                local clean_key="${key#"$lang."}"
                # Remove aspas simples se existirem no valor
                value="${value//\'/}"
                # Define uma variável global com o nome da chave e exporta
                export "$clean_key"="$value"
            fi
        fi
    done <<< "$translations"
}

# Função para selecionar o idioma
selectLanguage() {
    echo -e "👉  Select the language:\n"
    echo "1) Portuguese (Brazil)"
    echo "2) English"
    echo -en "\n📋 Choice (1 or 2): \n"
    read choice

    case $choice in
        1)
            echo "pt" > "$CONFIG_FILE"
            ;;
        2)
            echo "en" > "$CONFIG_FILE"
            ;;
        *)
            echo "Invalid option. Defaulting to English."
            echo "en" > "$CONFIG_FILE"
            ;;
    esac
}

# Verifica se o arquivo de configuração existe
if [[ -f "$CONFIG_FILE" ]]; then
    # Se existir, carrega o idioma do arquivo
    language=$(cat "$CONFIG_FILE")
else
    # Caso contrário, solicita a seleção de idioma
    selectLanguage
    language=$(cat "$CONFIG_FILE")
fi

if [[ $FORCE_SELECT == 1]]; then
    selectLanguage
    language=$(cat "$CONFIG_FILE")
    export FORCE_SELECT=0
fi

# Carregar todas as traduções para o idioma selecionado
loadAllTranslations "$language"