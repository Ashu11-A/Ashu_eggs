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

# Função principal do processo pai (substitua por seu código principal)
mainProcess() {
    echo "🟢 Processo principal rodando. Digite 'lang' para trocar o idioma."

    # Mantém o processo rodando até receber SIGUSR1
    while true; do
        echo "Processo principal ativo..."
        sleep 5
    done
}

# Função para escutar comandos do usuário
listenForCommands() {
    while true; do
        read -r command
        if [[ "$command" == "lang" ]]; then
            kill -SIGUSR1 "$PARENT_PID"  # Envia sinal ao processo pai
            selectLanguage
            language=$(cat "$CONFIG_FILE")
            loadAllTranslations "$language"
        fi
    done
}

# Handler para SIGUSR1 que pausa o processo principal
handleSignal() {
    echo -e "\n🌍 Alterando o idioma...\n"
}

# Configura o handler para SIGUSR1
trap handleSignal SIGUSR1

# Identifica o PID do processo pai
PARENT_PID=$$

# Inicia o listener em segundo plano
listenForCommands &

# Executa o processo principal
mainProcess