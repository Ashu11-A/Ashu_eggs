#!/bin/bash

CONFIG_FILE="language.conf"

# Função para carregar todas as traduções de um idioma
load_all_translations() {
    local lang="$1"
    
    # Lê o arquivo de tradução e filtra apenas as entradas para o idioma escolhido
    while IFS='=' read -r key value; do
        if [[ $key == "$lang"* ]]; then
            # Remove o prefixo do idioma da chave
            local clean_key=${key#"$lang."}
            # Define uma variável global com o nome da chave
            eval "$clean_key=\"$value\""
        fi
    done < translations.properties
}

# Função para selecionar o idioma
select_language() {
    echo "Select the language:"
    echo "1) Portuguese (Brazil)"
    echo "2) English"
    echo -n "Choice (1 or 2): "
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
    select_language
    language=$(cat "$CONFIG_FILE")
fi

# Carregar todas as traduções para o idioma selecionado
load_all_translations "$language"

# Usar as traduções como variáveis globais
echo "$greeting"
echo "$farewell"
